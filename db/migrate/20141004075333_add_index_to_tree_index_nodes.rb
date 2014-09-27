class AddIndexToTreeIndexNodes < ActiveRecord::Migration
  def change
    add_index :index_tree_index_nodes, [:root_element_id, :root_element_type], :name => 'index_index_tree_index_nodes_on_root_element'
  end
end
