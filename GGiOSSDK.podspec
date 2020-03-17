#
# Be sure to run `pod lib lint iOSSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GGiOSSDK'
  s.version          = '0.1.9'
  s.summary          = 'A iOSSDK is the testing sdk 0.1.9'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
I am trying to make live tracking sdk for all the developer so the can use easily in all project.
                       DESC

  s.homepage         = 'https://github.com/WhollySoftware/GGiOSSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'WhollySoftware' => 'whollysoftware@gmail.com' }
  s.source           = { :git => 'https://github.com/WhollySoftware/GGiOSSDK.git', :tag => s.version.to_s }
  s.social_media_url = 'https://whollysoftware.com'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Source/*.{swift,storyboard}'
  s.swift_version = '4.0'
  s.platforms = {
      "ios":"10.0"
  }
  s.dependency 'SwiftyJSON', '~> 4.0'
  s.dependency 'MBProgressHUD'
  s.dependency 'IQKeyboardManagerSwift', '6.2.1'
  s.dependency 'Socket.IO-Client-Swift'
   s.resource_bundles = {
     'GGiOSSDK' => ['Resources/*.png']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
end
