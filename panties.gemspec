# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'panties/version'

Gem::Specification.new do |spec|
  spec.name          = "panties"
  spec.version       = Panties::VERSION
  spec.authors       = ["Hendrik Mans"]
  spec.email         = ["hendrik@mans.de"]
  spec.summary       = %q{Command line client for #pants.}
  spec.description   = %q{#pants is a force for good. This is its command line client.}
  spec.homepage      = "https://github.com/hmans/panties"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'httparty', '~> 0.13.0'
  spec.add_dependency 'nokogiri', '~> 1.4'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
