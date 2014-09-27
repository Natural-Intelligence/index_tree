class CreateIndexTreeIndexNodes < ActiveRecord::Migration
  def change
    create_table :index_tree_index_nodes do |t|
      t.references :root_element, polymorphic: true, :null => false
      t.references :node_element, polymorphic: true, :null => false
      t.timestamps
    end
  end
end
