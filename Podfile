# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'AttendenceScanner' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

pod 'IQKeyboardManagerSwift'
pod 'SwiftyJSON'
pod 'Alamofire'
pod 'AlamofireImage'
pod 'ReachabilitySwift'
pod "CodeScanner"
pod 'CameraManager', '~> 5.1'
pod 'Toastify', :git => 'https://github.com/tusharvijay24/Toastify.git'
pod 'SwiftlyLoader', :git => 'https://github.com/tusharvijay24/SwiftlyLoader.git'
pod 'DropSwiftKit', :git => 'https://github.com/tusharvijay24/DropSwiftKit.git'

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
            end
        end
    end
end
