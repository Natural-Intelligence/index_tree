require "index_tree/version"
require "index_tree/engine"


require 'index_tree/finder_methods'
require 'index_tree/node_element'
require 'index_tree/root_element'
require 'models/index_node'
require 'index_tree/tree_preloader'

module IndexTree
  def self.table_name_prefix
    'index_tree_'
  end
end