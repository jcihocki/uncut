# encoding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "startup_giraffe/uncut/version"

Gem::Specification.new do |s|
  s.name        = "uncut"
  s.version     = StartupGiraffe::Uncut::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Johnny Cihocki"]
  s.email       = ["john@startupgiraffe.com"]
  s.homepage    = "http://startupgiraffe.com"
  s.summary     = "A just in time image resizer"
  s.description = "Uncut allows you to resize images from any source on the fly to changing specifications. Bring your own caching!"
  s.license     = "MIT"

  s.required_ruby_version     = ">= 1.9"
  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency("rmagick", ["> 2.13.0"])
  s.add_dependency("ruby-hmac" )

  s.files        = Dir.glob("lib/**/*") + %w(CHANGELOG.md LICENSE README.md)
  s.require_path = 'lib'
end
