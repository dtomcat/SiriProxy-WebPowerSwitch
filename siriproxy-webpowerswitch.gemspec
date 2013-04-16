# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-webpowerswitch"
  s.version     = "0.0.1" 
  s.authors     = ["Hagedorn"]
  s.email       = ["dtomcat@hotmail.com"]
  s.homepage    = "http://pachysoftware.com"
  s.summary     = %q{Web Power Switch Plugin}
  s.description = %q{This plugin interacts with the Web Power Switch by Digital-Loggers.com}

  s.rubyforge_project = "siriproxy-webpowerswitch"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "json"
end
