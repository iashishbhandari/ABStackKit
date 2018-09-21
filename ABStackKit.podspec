Pod::Spec.new do |s|
s.name    = "ABStackKit"
s.version = "0.1.0"
s.summary = "A Swift framework for scrollable StackView"
s.homepage = "https://bitbucket.org/iashishbhandari"
s.license  = 'MIT'
s.author = { "Ashish Bhandari" => "ashishbhandariplus@gmail.com" }
s.platform = :ios
s.source = { :git => "https://github.com/iashishbhandari/ABStackKit", :tag => "#{s.version}"}

s.swift_version = '4.2'
s.ios.deployment_target = '9.0'

s.source_files = "Source/*.swift"

s.framework = "UIKit"
end
