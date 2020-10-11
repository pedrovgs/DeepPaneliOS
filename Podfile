# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

def shared
    pod 'TensorFlowLiteSwift'
end

target 'DeepPanel' do
  use_frameworks!

  shared

  target 'DeepPanelTests' do
  
  end

end

target 'DeepPanelSample' do
  use_frameworks!

  shared
  
  target 'DeepPanelSampleTests' do
    inherit! :search_paths
  
  end

end
