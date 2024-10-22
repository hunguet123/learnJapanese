# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'learn_japanese' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'SwiftLint'
  pod 'lottie-ios'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'FirebaseAuth'
  pod 'FacebookLogin'
  pod 'GoogleSignIn'
  pod 'FirebaseFirestore'
  pod 'FirebaseStorage'
  pod 'SVProgressHUD'
  pod 'RealmSwift'
  pod 'L10n-swift'

  post_install do |installer|
   installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
     config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
   end
  end

end
