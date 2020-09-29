#
# Be sure to run `pod lib lint EasyRest.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "EasyRest"
  s.version          = "1.2.0"
  s.summary          = "A simple RestClient for iOS."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "A simple rest library for use in our iOS project's"

  s.homepage         = "https://github.com/lucasmpaim/EasyRest"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Lucas" => "lucasmpaim1@gmail.com" }
  s.source           = { :git => "https://github.com/lucasmpaim/EasyRest.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.default_subspec = 'Core'

  s.source_files = 'Sources/EasyRest/Classes/**/*'
# s.resource_bundles = {
#    'EasyRest' => ['EasyRest/Assets/*.png']
#  }

  # s.public_header_files = 'EasyRest/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'Alamofire', '~> 4.8.1'


  s.subspec 'Core' do |core|

  end

  s.subspec 'PromiseKit' do |promiseKit|
    promiseKit.source_files = ['Sources/EasyRest/Classes/**/*', 'Sources/PromiseKit/Classes/**/*']
    promiseKit.dependency 'PromiseKit', '~> 6.8'
  end

end
