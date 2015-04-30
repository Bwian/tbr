# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'prawn'
require 'prawn/table'

require 'tbr/version'
require 'tbr/call_detail'
require 'tbr/call_type'
require 'tbr/create_files'
require 'tbr/group'
require 'tbr/groups'
require 'tbr/log_it'
require 'tbr/parse_files'
require 'tbr/processor'
require 'tbr/service'
require 'tbr/services'
require 'tbr/service_summary'

Gem::Specification.new do |spec|
  spec.name          = "tbr"
  spec.version       = Tbr::VERSION
  spec.authors       = ["Brian Collins"]
  spec.email         = ["brian.pyrrho@bigpond.com"]
  spec.summary       = %q{Telstra Billing Reporter}
  spec.description   = %q{Parses Telstra OBS file and produces summary and detail management reports}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_dependency "prawn", "~> 2.0"
  spec.add_dependency "prawn-table", "~> 0.2"
  
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-nav"
end
