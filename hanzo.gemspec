# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hanzo/version'

Gem::Specification.new do |spec|
  spec.name          = 'hanzo'
  spec.version       = Hanzo::VERSION
  spec.authors       = ['Samuel Garneau']
  spec.email         = ['sgarneau@mirego.com']
  spec.description   = 'Hanzo is a tool to handle deployments in multiple environments on Heroku.'
  spec.summary       = 'Hanzo is a tool to handle deployments in multiple environments on Heroku.'
  spec.homepage      = 'https://github.com/mirego/hanzo'
  spec.license       = 'BSD 3-Clause'

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'phare', '~> 0.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'rubocop', '~> 0.49'

  spec.add_dependency 'highline', '>= 1.6.19'
end
