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
#  spec.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
#  spec.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib app)

  spec.add_dependency "bundler"
  spec.add_dependency 'rails'
  spec.add_dependency "rake", "~> 10.0"
end
