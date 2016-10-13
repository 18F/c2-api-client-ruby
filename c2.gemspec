# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'c2/version'

Gem::Specification.new do |s|
  s.name          = 'c2'
  s.version       = C2::VERSION
  s.authors       = ['Peter Karman']
  s.email         = ['peter.karman@gsa.gov']
  s.summary       = 'Ruby client for the C2 application'
  s.description   = 'Ruby client for the C2 application'
  s.homepage      = 'https://github.com/18F/c2-api-client-ruby'
  s.license       = 'CC0'

  s.add_runtime_dependency "faraday"
  s.add_runtime_dependency "faraday_middleware"
  s.add_runtime_dependency "excon"
  s.add_runtime_dependency "hashie"
  s.add_runtime_dependency "oauth2"
  s.add_development_dependency "rspec"
  s.add_development_dependency "dotenv"
  s.add_development_dependency "rake"
end
