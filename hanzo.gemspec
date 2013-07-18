# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hanzo/version'

Gem::Specification.new do |spec|
  spec.name          = 'hanzo'
  spec.version       = Hanzo::VERSION
  spec.authors       = ['Samuel Garneau']
  spec.email         = ['sgarneau@mirego.com']
  spec.description   = 'Hanzo easily handle multiple Heroku environments for an app'
  spec.summary       = 'Hanzo easily handle multiple Heroku environments for an app'
  spec.homepage      = 'https://github.com/mirego/palm'
  spec.license       = 'BSD 3-Clause'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'

  spec.add_dependency 'highline'
end
