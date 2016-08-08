Pod::Spec.new do |spec|
  spec.name             = 'ConsistencyManager'
  spec.version          = '2.0.0'
  spec.license          = { :type => 'Apache License, Version 2.0' }
  spec.homepage         = 'https://linkedin.github.io/ConsistencyManager-iOS'
  spec.authors          = 'LinkedIn'
  spec.summary          = 'Manages the consistency of immutable models.' 
  spec.source           = { :git => 'https://github.com/linkedin/ConsistencyManager-iOS.git', :tag => spec.version }
  spec.source_files     = 'ConsistencyManager/**/*.swift'
  spec.platform         = :ios, '8.0'
  spec.frameworks       = 'Foundation', 'UIKit'
end

