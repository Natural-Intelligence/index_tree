class AddElementTypeToIndex < ActiveRecord::Migration
  def change
    add_index :index_tree_index_nodes, [:node_element_type, :root_element_id, :root_element_type], :name => 'index_index_tree_index_nodes_on_node_element'
  end
end
