project 'RxMyCoordinator.xcodeproj'

platform :ios, '9.3'

target 'RxMyCoordinator' do
  use_frameworks!
  inhibit_all_warnings!
  
  pod 'RxCocoa'
  pod 'RxSwift'
  pod 'RxSwiftExt'

end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		if target.name == 'RxSwift'
			target.build_configurations.each do |config|
				if config.name == 'Debug'
					config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
				end
			end
		end
	end
end
