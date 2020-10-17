Pod::Spec.new do |s|
  s.name             = "DeepPanel"
  s.version          = "0.0.1"
  s.summary          = "Panels' segmentaiton made easy with artificial intelligence"
  s.license          = "Apache License, Version 2.0"
  s.homepage         = "https://github.com/pedrovgs/DeepPaneliOS"
  s.author           = "Pedro Vicente Gómez Sánchez"
  s.social_media_url = "https://twitter.com/pedro_g_s"
  s.source           = { :git => "https://github.com/pedrovgs/DeepPaneliOS.git", :tag => "#{s.version}" }
  s.ios.deployment_target = "9.0"
  s.requires_arc = "DeepPanel/**/*"
  s.source_files = "DeepPanel/**/*.{mm,m,h,hpp,cpp}"
  s.public_header_files = "DeepPanel/*.h"
  s.pod_target_xcconfig = { "OTHER_LDFLAGS" => "$(inherited) -lc++",
                               "OTHER_CFLAGS" => "$(inherited) -Wno-return-type -Wno-logical-op-parentheses -Wno-conversion -Wno-parentheses -Wno-unused-function -Wno-unused-variable -Wno-switch -Wno-unused-command-line-argument",
                               "OTHER_CPLUSPLUSFLAGS" => "$(inherited) -DSILENT -DRARDLL $(OTHER_CFLAGS)" }
  s.compiler_flags = "-Xanalyzer -analyzer-disable-all-checks"
end