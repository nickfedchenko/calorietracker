# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'CalorieTracker' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CalorieTracker
  pod 'R.swift'
  pod 'SwiftLint'
  pod 'Texture'
  pod 'ApphudSDK'
  pod 'AlignedCollectionViewFlowLayout'
  pod 'NVActivityIndicatorView'
  pod 'Amplitude'
  pod 'FirebaseCrashlytics'

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.2'
         end
    end
  end
end
end
