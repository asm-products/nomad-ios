//
//  ViewController.swift
//  Nomad
//
//  Created by Jeroen Leenarts on 30-10-14.
//  Copyright (c) 2014 Nomad. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let cellIdentifier = "googlePlacesAutocompleteCell";
    
    var searchResulsPlaces = [SPGooglePlacesAutocompletePlace]()
    //TODO: we need an API key
    let searchQuery = SPGooglePlacesAutocompleteQuery(apiKey: "")
    
    let locationManager = CLLocationManager()

    var selectedPlaceAnnotation: MKPointAnnotation?
    
    var shouldBeginEditing = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        self.searchDisplayController?.searchResultsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        self.searchDisplayController!.searchBar.placeholder = "Search or Address"
    }
    
    @IBAction func recenterMapToUserLocation(sender: AnyObject) {
        self.startLocationUpdates()
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            println("notdetermined")
        case .Restricted:
            println("restricted")
        case .Denied:
            println("denied")
        default:
            mapView.showsUserLocation = true
            let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            let region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResulsPlaces.count
    }
    
    func placeAtIndexPath(indexPath: NSIndexPath) -> SPGooglePlacesAutocompletePlace {
        return searchResulsPlaces[indexPath.row]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel.text = placeAtIndexPath(indexPath).name
        return cell
    }
    
    
    func recenterMapToPlacemark(placemark: CLPlacemark) {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: placemark.location.coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    
    func addPlacemarkAnnotationToMap(placemark: CLPlacemark, address: String) {
        self.mapView.removeAnnotation(selectedPlaceAnnotation)
        
        selectedPlaceAnnotation = MKPointAnnotation()
        selectedPlaceAnnotation?.coordinate = placemark.location.coordinate
        selectedPlaceAnnotation?.title = address
        
        self.mapView.addAnnotation(selectedPlaceAnnotation)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let place = placeAtIndexPath(indexPath)
        place.resolveToPlacemark { (placemark: CLPlacemark?, address: String?, error: NSError?) -> Void in
            if let myError = error {
                let alertView = UIAlertView(title: "Could not map selected place", message: myError.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            } else if let myPlacemark = placemark {
                self.addPlacemarkAnnotationToMap(myPlacemark, address: address!)
                self.recenterMapToPlacemark(myPlacemark)
                self.searchDisplayController?.setActive(false, animated: true)
                self.searchDisplayController?.searchResultsTableView.deselectRowAtIndexPath(indexPath, animated: false)
            }
        }
    }
    
    func handleSearchForSearchString(searchString: String) {
        searchQuery?.location = self.mapView.userLocation.coordinate
        searchQuery?.input = searchString
        
        searchQuery?.fetchPlaces({ (places: [AnyObject]?, error: NSError?) -> Void in
            if let myError = error {
                let alertView = UIAlertView(title: "Could not fetch places", message: myError.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            } else if let myPlaces = places as? [SPGooglePlacesAutocompletePlace] {
                self.searchResulsPlaces = myPlaces
                self.searchDisplayController?.searchResultsTableView.reloadData()
            }
        })
    }

    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.handleSearchForSearchString(searchString)
        
        // Return true to cause the search result table view to be reloaded.
        return true;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchBar.isFirstResponder() {
            // User tapped the 'clear' button.
            shouldBeginEditing = false;
            searchDisplayController?.setActive(false, animated: true)
            mapView .removeAnnotation(selectedPlaceAnnotation)
        }
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        if shouldBeginEditing {
            let animationDuration = NSTimeInterval(0.3)
            UIView.beginAnimations("temp", context: nil)
            UIView.setAnimationDuration(animationDuration)
            // Animate in the table view.
            searchDisplayController?.searchResultsTableView.alpha = 0.75;
            UIView.commitAnimations()
            
            searchDisplayController?.searchBar.setShowsCancelButton(true, animated: true)
        }
        
        let boolToReturn = shouldBeginEditing
        shouldBeginEditing = true
        return boolToReturn
    }
    

    func mapView(mapViewIn: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if mapViewIn != mapView || annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        let annotationIdentifier = "SPGooglePlacesAutocompleteAnnotation"
        var annotationView: MKPinAnnotationView? = self.mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) as MKPinAnnotationView?
        
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }
        
        annotationView?.animatesDrop = true
        annotationView?.canShowCallout = true
        
        let detailButton = UIButton.buttonWithType(.DetailDisclosure) as UIButton
        detailButton.addTarget(self, action: Selector("annotationDetailButtonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)

        annotationView?.rightCalloutAccessoryView = detailButton
        return annotationView
    }
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        // Whenever we've dropped a pin on the map, immediately select it to present its callout bubble.
        mapView.selectAnnotation(selectedPlaceAnnotation, animated:true)
    }

    func annotationDetailButtonPressed(sender: AnyObject) {
        // Detail view controller application logic here.
        println("Detail button pressed")
    }
    
    func startLocationUpdates() {
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .Restricted:
            println("restricted")
        case .Denied:
            println("denied")
        default:
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.distanceFilter = CLLocationDistance(50)
            
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        startLocationUpdates()
    }
}

