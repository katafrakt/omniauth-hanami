# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/hanami/version'

Gem::Specification.new do |spec|
  spec.name          = 'omniauth-hanami'
  spec.version       = Omniauth::Hanami::VERSION
  spec.authors       = ['Paweł Świątkowski']
  spec.email         = ['inquebrantable@gmail.com']

  spec.summary       = %q{A plugin for omniauth for Hanami applications}
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'omniauth', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
end
