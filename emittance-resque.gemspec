# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'emittance/resque/version'

Gem::Specification.new do |spec|
  spec.name          = 'emittance-resque'
  spec.version       = Emittance::Resque::VERSION
  spec.authors       = ['Tyler Guillen']
  spec.email         = ['tyguillen@gmail.com']

  spec.summary       = 'The "resque" dispatch strategy for the emittance gem.'
  spec.description   = 'The "resque" dispatch strategy for the emittance gem.'
  spec.homepage      = 'https://github.com/aastronautss/emittance-resque'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'emittance', '~> 1.0'
  spec.add_dependency 'resque'

  spec.add_development_dependency 'activerecord'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'yard'
end
