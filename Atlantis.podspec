Pod::Spec.new do |s|
 
  s.name         = "Atlantis"
  s.version      = "1.0"
  s.summary      = "A versatile and type-agnostic Swift logging framework."
 
  s.description  = <<-DESC
    I was inspired by Dave Wood's XCGLogger, but felt that it was lacking in utility and some key attributes that xcode's native print() function had. I took some of his code and added a couple of things and came up with this framework.
                      DESC
 
  s.homepage     = "https://github.com/DrewKiino/Atlantis"
  # s.screenshots  = "https://github.com/DrewKiino/Atlantis/raw/master/Images/atlantis-logo.png?raw=true"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "DrewKiino" => "andrew@totemv.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/DrewKiino/Atlantis.git", :tag => s.version }
  s.source_files  = "XCode/Atlantis/Atlantis/Source/*.swift"
 
end