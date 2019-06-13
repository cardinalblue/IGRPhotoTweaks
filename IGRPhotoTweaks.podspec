Pod::Spec.new do |spec|
  spec.name                = 'IGRPhotoTweaks'
  spec.version             = '1.0.12-cb'
  spec.platform            = :ios, '10.0'
  
  spec.license             = { :type => "MIT", :file => "LICENSE" }
  spec.homepage            = 'https://github.com/cardinalblue/IGRPhotoTweaks'
  spec.authors             = {'Vitalii Parovishnyk' => 'korich.vi.p@gmail.com'}
  spec.summary             = 'Drag, Rotate, Scale and Crop.'
  
  spec.source              = {:git => 'https://github.com/cardinalblue/IGRPhotoTweaks.git', :tag => spec.version}
  
  spec.source_files        = 'IGRPhotoTweaks/**/*.{h,swift}'
  
  spec.framework           = 'Foundation', 'CoreGraphics', 'UIKit', 'Photos'
  spec.requires_arc        = true
  spec.swift_version       = '4.2'

  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
end
