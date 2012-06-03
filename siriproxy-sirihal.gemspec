# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-sirihal"
  s.version     = "0.0.1" 
  s.authors     = ["hagedorn"]
  s.email       = ["dtomcat@hotmial.com"]
  s.homepage    = "http://google.com"
  s.summary     = %q{HAL2000 Home Automation Plugin}
  s.description = %q{This plugin accepts commands and send them to HAL2000}

  s.rubyforge_project = "siriproxy-sirihal"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "json"
end
