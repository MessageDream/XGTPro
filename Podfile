source 'https://github.com/CocoaPods/Specs.git'
 
platform :ios, '7.1'
inhibit_all_warnings!
 
xcodeproj 'XGTPro'
target 'XGTPro', :exclusive => true do
  pod 'Masonry'
  pod 'AFNetworking'
  pod 'ReactiveCocoa'
  pod 'ReactiveViewModel'
  pod 'JSONModel'
  pod 'AFNetworking-RACExtensions'
  pod 'SDWebImage'
  pod 'SVProgressHUD'
  pod 'XXNibBridge','~> 2.1'
end


 
post_install do |installer|
  installer.project.targets.each do |target|
    puts "#{target.name}"
  end
end