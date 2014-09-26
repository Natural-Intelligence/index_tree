require "index_tree/version"
require "index_tree/engine"
require 'index_tree/tree_preloader'

require 'models/concerns/finder_methods'
require 'models/concerns/node_element'
require 'models/concerns/root_element'

module IndexTree
  def self.table_name_prefix
    'index_tree_'
  end
end