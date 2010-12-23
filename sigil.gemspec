# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sigil/version"

Gem::Specification.new do |s|
  s.name        = "sigil"
  s.version     = Sigil::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Steve Hoeksema"]
  s.email       = ["steve@seven.net.nz"]
  s.homepage    = "http://github.com/steveh/sigil"
  s.summary     = "Signs and verifies a set of parameters"
  s.description = "Signs and verifies a set of parameters"

  s.rubyforge_project = "sigil"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency("activesupport", [">= 3.0.0"])
  s.add_runtime_dependency("i18n", [">= 0"])
  s.add_development_dependency("rspec", ["~> 2.1.0"])
  s.add_development_dependency("bundler", ["~> 1.0.0"])
  s.add_development_dependency("rcov", [">= 0"])
  s.add_development_dependency("activesupport", [">= 3.0.0"])
end