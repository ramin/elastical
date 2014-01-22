# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elastical/version'

Gem::Specification.new do |spec|
  spec.name          = "elastical"
  spec.version       = Elastical::VERSION
  spec.authors       = ["ramin keene"]
  spec.email         = ["raminkeene@gmail.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 3.2"
  spec.add_dependency "stretcher", "~> 1.9"

  spec.add_development_dependency "activerecord", "~> 3.2"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency "rspec-rails", "~> 2.14.1"
end
