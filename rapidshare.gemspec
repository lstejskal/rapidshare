# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rapidshare/version"

Gem::Specification.new do |s|
  s.name        = "rapidshare"
  s.version     = Rapidshare::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tomasz Mazur", "Lukas Stejskal"]
  s.email       = ["defkode@gmail.com", "lucastej@gmail.com"]
  s.homepage    = "http://github.com/defkode/rapidshare"
  s.summary     = %q{low-level wrapper for Rapidshare API}
  s.description = %q{Provides low-level wrapper for Rapidshare API.}

  s.rubyforge_project = "rapidshare"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency('activesupport', '~> 3.2.8')
  s.add_dependency('rake', '~> 0.9.2')
  s.add_dependency('curb', '~> 0.8.1')
  s.add_dependency('progressbar', '~> 0.11.0')
  
  # development dependencies
  s.add_development_dependency('yard', '~> 0.7')
  s.add_development_dependency('rdiscount', '~> 1.6')
  s.add_development_dependency('simplecov', '~> 0.6.4')

  # test dependencies 
  s.add_development_dependency('shoulda', '~> 2.11')
  s.add_development_dependency('turn', '~> 0.9.4')
  s.add_development_dependency('fakeweb', '~> 1.3')
  s.add_development_dependency('mocha', '~> 0.10')
end
