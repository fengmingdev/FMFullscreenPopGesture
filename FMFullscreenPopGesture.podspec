#
# Be sure to run `pod lib lint FMFullscreenPopGesture.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FMFullscreenPopGesture'
  s.version          = '2.0.0'
  s.summary          = 'A UINavigationController\'s category to enable fullscreen pop gesture in Swift.'

  s.description      = <<-DESC
  An UINavigationController's category to enable fullscreen pop gesture in an iOS7+ system style with Swift implementation.

  This is a Swift rewrite of the original Objective-C version (https://github.com/fengmingdev/FMFullscreenPopGesture).

  Features:
  - ✅ Fullscreen pan gesture support
  - ✅ Per-view-controller control
  - ✅ Custom gesture begin logic
  - ✅ Limited trigger area support
  - ✅ Navigation bar appearance management
  - ✅ RTL layout support
  - ✅ iOS 13.0+ support
  - ✅ Swift Package Manager support
                       DESC

  s.homepage         = 'https://github.com/fengmingdev/FMFullscreenPopGesture'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fengming' => 'your@email.com' }
  s.source           = { :git => 'https://github.com/fengmingdev/FMFullscreenPopGesture.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.5'

  s.source_files = 'FMFullscreenPopGesture-Swift/Sources/**/*.swift'

  s.frameworks = 'UIKit'

  # Pod dependencies
  # s.dependency 'AFNetworking', '~> 2.3'
end
