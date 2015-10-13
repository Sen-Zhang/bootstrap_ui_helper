# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bootstrap_ui_helper/version'

Gem::Specification.new do |spec|
  spec.name          = 'bootstrap_ui_helper'
  spec.version       = BootstrapUiHelper::VERSION
  spec.authors       = ['Sen Zhang']
  spec.email         = ['solowolf21@gmail.com']
  spec.summary       = %q{Bootstrap UI Helper}
  spec.description   = %q{Bootstrap UI Helper Engine}
  spec.homepage      = 'https://github.com/Sen-Zhang/bootstrap_ui_helper'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
