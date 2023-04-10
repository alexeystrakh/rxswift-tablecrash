source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '14.0'
target 'TableCrash' do
  use_frameworks!
  pod 'RxSwift', '5.1.1'
  pod 'RxCocoa', '5.1.1'

  post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
               end
          end
   end
end
end
