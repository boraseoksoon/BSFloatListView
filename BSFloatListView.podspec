#
# Be sure to run `pod lib lint BSFloatListView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BSFloatListView'
  s.version          = '0.1.0'
  s.summary          = 'BSFloatListView: Amazing Floating List View?'

  #   * Try to keep it short, snappy and to the point.
  s.description      = 'BSFloatListView may be amazing floating list view that works like a charm!'

  s.homepage         = 'https://github.com/boraseoksoon/BSFloatListView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'boraseoksoon@gmail.com' => 'boraseoksoon@gmail.com' }
  s.source           = { :git => 'https://github.com/boraseoksoon/BSFloatListView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '4.2'

  s.source_files = 'BSFloatListView/Classes/**/*'
  s.frameworks = 'UIKit'
  
  s.resources = ['BSFloatListView/Assets/*.xib']
   s.resource_bundles = {
     'BSFloatListView' => ['BSFloatListView/Assets/*']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  
  # s.dependency 'AFNetworking', '~> 2.3'
end
