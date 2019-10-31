# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'naas/client/version'

Gem::Specification.new do |spec|
  spec.name          = "naas-client"
  spec.version       = Naas::Client::VERSION
  spec.authors       = ["Nate Klaiber"]
  spec.email         = ["nate@deviceindependent.com"]
  spec.summary       = %q{ Client for the NAAS API.}
  spec.description   = %q{ Client for interacting with the NAAS API.}
  spec.homepage      = "https://github.com/quicksprout/naas-api-client-ruby.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency("bundler", "~> 1.7")
  spec.add_development_dependency("rake", "~> 10.0")
  spec.add_development_dependency("rspec")
  spec.add_development_dependency("yard")
  spec.add_development_dependency("webmock")

  spec.add_dependency('faraday')
  spec.add_dependency('mimemagic')
  spec.add_dependency('mime-types')
  spec.add_dependency('faraday_middleware')
  spec.add_dependency('multi_json')
  spec.add_dependency('dotenv')
  spec.add_dependency('addressable')
  spec.add_dependency('restless_router')
  spec.add_dependency("terminal-table")
end
