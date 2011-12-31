# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-piwik"
  s.version     = "0.0.1" 
  s.authors     = ["Evan Coleman"]
  s.email       = [""]
  s.homepage    = "http://evancoleman.net"
  s.summary     = %q{A Siri Proxy Plugin for Piwik}
  s.description = %q{A plugin for SiriProxy that will allow you to check Piwik stats}

  s.rubyforge_project = "siriproxy-piwik"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  
  s.add_runtime_dependency "piwik"
end
