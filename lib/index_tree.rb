require "index_tree/version"
require "index_tree/engine"


require 'index_tree/finder_methods'
require 'index_tree/node_element'
require 'index_tree/root_element'
require 'models/index_node'
require 'index_tree/tree_preloader'

require 'index_tree/acts_as_indexed_node'
require 'index_tree/railtie'

module IndexTree
  def self.table_name_prefix
    'index_tree_'
  end
end