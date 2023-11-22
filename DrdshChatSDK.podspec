#
# Be sure to run `pod lib lint iOSSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DrdshChatSDK'
  s.version          = '1.0.2'
  s.summary          = 'To Build Excellent Customer Experience, Connect With DRDSH.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
We have influential engagement products and potent customer service with flexibility and reliability for any business.
                       DESC

  s.homepage         = 'https://github.com/cto-htfsa/drdsh-sdk-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'htf' => 'cto@htf.sa' }
  s.source           = { :git => 'https://github.com/cto-htfsa/drdsh-sdk-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'DrdshChatSDK/Classes/**/*'
  s.swift_version = '4.0'
  s.platforms = {
      "ios":"13.0"
  }
  s.dependency 'SwiftyJSON', '~> 4.0'
  s.dependency 'MBProgressHUD'
  s.dependency 'IQKeyboardManagerSwift', '6.2.1'
  s.dependency 'Socket.IO-Client-Swift','15.2.0'
   s.resource_bundles = {
     'DrdshChatSDK' => ['DrdshChatSDK/Assets/**/*']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
end
