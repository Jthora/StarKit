Pod::Spec.new do |s|

  s.name         = "StarKit"
  s.version      = "1.2.2"
  s.summary      = "Core Astrology Framework for calculating planetary harmonics."


  s.description  = "StarKit generates StarCharts for use in Predicting Future and Real-Time Events on Earth"
  s.homepage     = "https://github.com/Jthora/StarKit"
  s.license      = { :type => "Creative Commons Zero v1.0 Universal", :file => "LICENSE" }

  s.author             = { "Jordan Trana" => "jono@thora.show" }
  # s.social_media_url   = "https://twitter.com/Jordan Trana"

  s.ios.deployment_target = '15.2'
  s.osx.deployment_target = '12.2'
  #s.watchos.deployment_target = "8.3"
  #s.tvos.deployment_target = "9.0"

  s.swift_version = '5.0'
  s.source       = { :git => "https://github.com/Jthora/StarKit.git", :tag => s.version.to_s }
  s.source_files  = 'StarKit/**/*.{swift,h,m}'
  s.exclude_files = 'Classes/Exclude'

  s.frameworks = "Foundation"

  s.resources = ['StarKit/**/*.{plist,json,bundle}']
  s.resource_bundles = {
    'StarKit' => ['StarKit/**/*.{otf,ttf,xib,storyboard,xcassets,png,json,imageset}']
  }
  s.public_header_files = "StarKit/**/*.h"

  s.requires_arc = true

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 x86_64 i386 armv7' }
  s.user_target_xcconfig = { 'VALID_ARCHS' => 'arm64 x86_64 i386 armv7' }

  s.dependency 'SwiftAA'
  s.dependency 'ObjCAA'

end
