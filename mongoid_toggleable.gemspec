# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'mongoid_toggleable/version'

Gem::Specification.new do |spec|
  spec.name        = 'mongoid_toggleable'
  spec.version     = MongoidToggleable::VERSION
  spec.authors     = ['PJ Kelly']
  spec.email       = ['pj@crushlovely.com']
  spec.homepage    = 'https://github.com/crushlovely/mongoid_toggleable'
  spec.summary     = 'Toggleable attributes for your Mongoid models.'
  spec.description = 'Toggleable attributes for your Mongoid models.'

  spec.rubyforge_project = 'mongoid_toggleable'

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").collect { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency('activesupport', '>=2.1.0')

  spec.add_development_dependency('bundler', '~> 1.3')
  spec.add_development_dependency('pry')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('mongoid-rspec')
  spec.add_development_dependency('rubocop')
  spec.add_development_dependency('timecop')
  spec.add_development_dependency('guard')
  spec.add_development_dependency('guard-rspec')
  spec.add_development_dependency('guard-rubocop')
  spec.add_development_dependency('codeclimate-test-reporter')

  spec.add_runtime_dependency('mongoid')
end
