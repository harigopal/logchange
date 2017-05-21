# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logchange/version'

Gem::Specification.new do |spec|
  spec.name    = 'logchange'
  spec.version = Logchange::VERSION
  spec.authors = ['Hari Gopal']
  spec.email   = ['mail@harigopal.in']

  spec.summary     = 'An alternative approach to managing a changelog.'
  spec.description = 'Logs changes to individual YAML files and offers a release mechanism.'
  spec.homepage    = 'https://github.com/harigopal/logchange'
  spec.license     = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.required_ruby_version = '>= 2.2.0'
  spec.bindir                = 'exe'
  spec.executables           = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths         = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry', '~> 0.10'
end
