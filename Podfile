# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'
project 'learn_japanese.xcodeproj'

target 'learn_japanese' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # UI/Utility pods
  pod 'SwiftLint', '0.58.2'
  pod 'lottie-ios', '4.5.1'
  pod 'SVProgressHUD', '2.3.1'
  pod 'L10n-swift', '5.10.3'
  pod 'SQLite.swift', '0.15.3'
  pod 'gRPC-Core', '~> 1.62.0'
  
  # Firebase pods - sử dụng phiên bản mới hơn và cấu trúc đơn giản
  pod 'Firebase/Database', '10.29.0'
  pod 'Firebase/Auth', '10.29.0'
  pod 'Firebase/Firestore', '10.29.0'
  pod 'Firebase/Storage', '10.29.0'
  # pod 'Firebase/Analytics' # Thêm nếu bạn cần Analytics
  # pod 'Firebase/Messaging' # Thêm nếu bạn cần Cloud Messaging (FCM)
  # ... thêm các dịch vụ Firebase khác nếu cần
  
  # Đăng nhập bên thứ ba
  pod 'FacebookLogin'
  # pod 'FacebookCore' # Thử bỏ dòng này, vì FacebookLogin thường đã bao gồm nó
  pod 'GoogleSignIn'
  
  # GoogleMLKit
  pod 'GoogleMLKit/DigitalInkRecognition', '4.0.0'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      # Xử lý đặc biệt cho BoringSSL-GRPC
      #      if target.name == 'BoringSSL-GRPC'
      #        target.build_configurations.each do |config|
      #          # Loại bỏ flag -G không được hỗ trợ
      #          config.build_settings['OTHER_CFLAGS'] = '$(inherited) -fno-objc-arc -DBORINGSSL_PREFIX=GRPC'
      #          config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = '$(inherited) OPENSSL_NO_ASM=1'
      #        end
      #      end
      #
      if target.name == 'BoringSSL-GRPC'
        target.source_build_phase.files.each do |file|
          if file.settings && file.settings['COMPILER_FLAGS']
            flags = file.settings['COMPILER_FLAGS'].split
            flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
            file.settings['COMPILER_FLAGS'] = flags.join(' ')
          end
        end
      end
      
      if target.name == 'abseil'
        target.build_configurations.each do |config|
          config.build_settings['CLANG_CXX_LANGUAGE_STANDARD'] = 'gnu++14'
        end
      end
      
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
        
        # Tắt các cảnh báo về vấn đề tương thích
        #        config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
        # Thêm cấu hình cho Apple Silicon
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      end
    end
  end
end
