# Nomad

##Prepare and run the app

The project is based on [CocoaPods].(http://cocoapods.org) To prepare the project, take the usual steps for any CocoaPods project.

If you haven't yet, run:
```shell
sudo gem install cocoapods
````

Then:
```shell
pod install
open Nomad.xcworkspace
```

For testing purposes a Google Places Api key is needed.

Please see here for more info: (https://developers.google.com/places/documentation/#Authentication)[https://developers.google.com/places/documentation/#Authentication]

Once you have obtained your API key search for the string "ADD-YOUR-API-HERE". And replace it with your API key.

Be carefull not to commit your key.

## Before submitting your work for review
Nomad uses the [KIF testing framework](https://github.com/kif-framework/KIF). You should read up on it on it's website. When creating new functionality you are expected to make sure you extend the current test set and to make sure existing tests don't break. You might need to adjust some tests for this. The key is adjusting, not simply deleting.

To run all unit tests and functional tests, just run all unit tests on the project. For Xcode that would mean you would press CMD+U. The tests should run on both devices and simulators.

## Find the best places to work remotely

This is a product being built by the Assembly community. You can help push this idea forward by visiting [https://assembly.com/nomad](https://assembly.com/nomad).

### How Assembly Works

Assembly products are like open-source and made with contributions from the community. Assembly handles the boring stuff like hosting, support, financing, legal, etc. Once the product launches we collect the revenue and split the profits amongst the contributors.

Visit [https://assembly.com](https://assembly.com) to learn more.
