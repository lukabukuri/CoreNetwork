Pod::Spec.new do |s|
  s.name             = "CoreNetwork"
  s.version          = "1.0"
  s.summary          = "CoreNetwork - Network Layer Framework"
  s.homepage         = "https://github.com/lukabukuri/CoreNetwork"
  s.license          = 'Code is MIT, then custom font licenses.'
  s.author           = { "JSC TBC Bank" => "info@tbcbank.com.ge" }
  s.source           = { :git => "https://github.com/lukabukuri/CoreNetwork.git", :tag => s.version }

  s.platform     = :ios, '13.0'
  s.requires_arc = true

  s.source_files = 'CoreNetwork/Sources/*.swift', 'CoreNetwork/Sources/**/*.swift'

  s.frameworks = 'UIKit', 'Foundation', 'SystemConfiguration', 'XCTest'
  s.swift_version = '5.0'	
end