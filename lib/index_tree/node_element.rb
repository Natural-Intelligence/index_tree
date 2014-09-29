require 'active_support/concern'

module IndexTree
  module NodeElement
    extend ActiveSupport::Concern

    included do
      # Pointer to the index node
      has_one :index_tree_index_node, :class_name => 'IndexTree::IndexNode', as: :node_element

      # Creates index node for current tree node, and invokes index node creation for each defined association
      # @param [root_element] Id of the root
      def create_index_node(root_element)
        IndexTree::IndexNode.create!(:root_element => root_element, :node_element => self)
        create_index_nodes_for_children(root_element)
      end

      private

      class_attribute :child_nodes

      # Empty default value
      self.child_nodes = {}

      # Define what associations are child nodes
      # It will be used to create Index nodes when the root element will be saved
      # @param [*attributes] list of associations
      def self.child_nodes(*attributes)
        self.child_nodes = valid_associations(attributes)
      end

      # @return [valid_associations] map with existing associations
      def self.valid_associations(attributes)
        valid_associations = {}

        # Check if the declared input is an existing association
        Array(attributes).each do |association_name|
          valid_associations[association_name] = reflections[association_name] if reflections[association_name]
        end

        return valid_associations
      end

      # Invoke index node creation for children nodes
      # @param [root_element] id of the root element
      def create_index_nodes_for_children(root_element)

        self.child_nodes.keys.each do |association_name|
          association_value = send(association_name)

          Array(association_value).each do |child_node|
            child_node.create_index_node(root_element)
          end
        end
      end

    end
  end
end
