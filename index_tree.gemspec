# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'index_tree/version'

Gem::Specification.new do |spec|
  spec.name          = "index_tree"
  spec.version       = IndexTree::VERSION
  spec.authors       = ["Natural Intelligence"]
  spec.email         = %w(info@naturalint.com)
  spec.description   = %q{}
  spec.summary       = %q{}
  spec.homepage      = 'http://www.naturalint.com'

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = %w(lib app)

  spec.add_dependency "activerecord"
end
