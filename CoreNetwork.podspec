Pod::Spec.new do |s|
  s.name             = "CoreNetwork"
  s.version          = "1.1.4"
  s.summary          = "CoreNetwork - Network Layer Framework"
  s.homepage         = "https://tfssrv.hq.tbc/DefaultCollection/TBC.Common.iOS/_git/CoreNetwork"
  s.license          = 'Code is MIT, then custom font licenses.'
  s.author           = { "JSC TBC Bank" => "info@tbcbank.com.ge" }
  s.source           = { :git => "https://tfssrv.hq.tbc/DefaultCollection/TBC.Common.iOS/_git/CoreNetwork", :tag => "#{s.version}" }

  s.platform     = :ios, '13.0'
  s.requires_arc = true

  s.source_files = 'CoreNetwork/Sources/**/*'

  s.frameworks = 'UIKit', 'Foundation', 'SystemConfiguration'
  s.swift_version = '5.0'	
end

