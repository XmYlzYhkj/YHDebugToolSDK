#
# Be sure to run `pod lib lint YHDebugToolSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YHDebugToolSDK'
  s.version          = '1.0.0'
  s.summary          = 'This sdk can switch develop environment and detect network.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
 This sdk can switch develop environment and detect network.
                       DESC

  s.homepage         = 'https://github.com/zhengxiaolang/YHDebugToolSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhengxiaolang' => 'haifeng3099@126.com' }
  s.source           = { :git => 'https://github.com/zhengxiaolang/YHDebugToolSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'YHDebugToolSDK/Classes/**/*'
  
  # s.resource_bundles = {
  #   'YHDebugToolSDK' => ['YHDebugToolSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'FLEX', :configurations => ['Debug']
end
