Pod::Spec.new do |spec|

  spec.name         = "DeepPanel"
  spec.version      = "0.0.1"
  spec.summary      = "Panels' segmentaiton made easy with artificial intelligence"
  spec.description  = "iOS library used to implement comic vignettes segmentation using a machine learning method named deep learning."
  spec.homepage     = "https://github.com/pedrovgs/DeepPaneliOS"
  spec.license      = "Apache License, Version 2.0"
  spec.author       = "Pedro Vicente Gómez Sánchez"
  spec.social_media_url   = "https://twitter.com/pedro_g_s"
  spec.source           = { :git => 'https://github.com/pedrovgs/DeepPaneliOS.git' }
  spec.source_files  = "DeepPanel", "DeepPanel/**/*.{h,m,h,mm,swift,tflite}"
  spec.requires_arc = true
  spec.dependency "TensorFlowLiteSwift"
  spec.platform = :ios
  spec.ios.deployment_target = '9.0'
  spec.static_framework = true

end