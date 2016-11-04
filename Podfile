# Uncomment this line to define a global platform for your project
 platform :ios, '9.0'
# Uncomment this line if you're using Swift
 use_frameworks!
swift_version = "3.0"

target 'EliteBase' do
	pod 'MBProgressHUD'
	pod 'Alamofire', '~> 4.0'
	pod 'SwiftyJSON'
	pod 'Braintree'
	pod 'PromiseKit', '~> 4.0'
	pod 'CVCalendar', '~> 1.4.0'
end

target 'EliteBaseTests' do

end

post_install do |installer|
	installer.pods_project.build_configurations.each do |config|
		config.build_settings['SWIFT_VERSION'] = "3.0"
		config.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = "YES"
	end
end
