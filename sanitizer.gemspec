# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sanitizer/version"

Gem::Specification.new do |s|
  s.name        = "sanitizer"
  s.version     = Sanitizer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Marcelo Eden"]
  s.email       = ["edendroid@gmail.com"]
  s.homepage    = "http://github.com/3den/ruby-sanitizer"
  s.summary     = %q{The simplest string cleaner ever made}
  s.description = %q{Sanitizer.clean(text)}

  s.rubyforge_project = "sanitizer"

  s.files         = Dir.glob("{lib}/**/*")
  s.test_files    = Dir.glob("{spec}/**/*_spec.rb")
  s.require_paths = ["lib"]
  
  # Dependencies
  s.add_development_dependency("rspec", "~> 2.3.0")
  s.add_development_dependency("ruby-debug")
  s.add_dependency("htmlentities", "~> 4.3.0")
end
