# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'index_tree/version'

Gem::Specification.new do |spec|
  spec.name          = "index_tree"
  spec.version       = IndexTree::VERSION
  spec.authors       = ["Alex Stanovsky"]
  spec.email         = %w(info@naturalint.com)
  spec.homepage      = 'http://www.naturalint.com'

  spec.description   = %q{Eager loads trees by indexing the nodes of the tree. The number of queries needed to load a tree is N,
when N is number of different models(ActiveRecords) in the tree}

  spec.summary       = %q{This Gem eager loads trees by indexing the nodes of the tree. The number of queries needed to load a tree is N,
when N is number of different models(ActiveRecords) in the tree.
Each inner object in the tree have an index node instance that is connecting it to the root.
When the root of the tree is loaded, only the objects that are in the tree are fetched(Pruning).
The index nodes are created when the root element is saved.}

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = %w(lib app)

  spec.add_dependency "activerecord"
end
