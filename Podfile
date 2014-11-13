# platform :ios, '8.1'

source 'https://github.com/CocoaPods/Specs.git'

pod 'SPGooglePlacesAutocomplete'

target 'Nomad' do

end

target 'NomadTests' do

end

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-Nomad/Pods-Nomad-Acknowledgements.plist', 'Nomad/Resource/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end

