require 'active_support/concern'

# Each inner object in the decision tree have an index node instance that is connecting it to the root.
# It is used in eager load of Root element, for fetching only the objects that are in the tree of a specific root.
# Each of the nodes in the tree should have one of the following declarations:
#
#     include IndexTree::RootElement - for root element
#     include IndexTree::NodeElement - for node elements
#
# And declare what associations are used to define the relations of the tree.
# Usage:
#
#      child_nodes :name_of_exisiting_association
#
# Example:
#
#   class world
#     include IndexTree::RootElement
#
#     has_many :continents
#     has_many :seas
#
#     child_nodes :continents
#   end
#
#   class continent
#     include IndexTree::NodeElement
#
#     belongs_to :world
#     has_many :countries
#
#     child_nodes :countries
#   end
#
#                 =========
#                 | World |
#                 =========
#                 ^   ^   ^
#           ______|   |   |______
#          |          |          |
#          |          |          |
#          |          |          |
#      ========    ========   ========
#      | Asia |    |Africa|   |Europe|
#      ========    ========   ========
#      ^  ^  ^     ^  ^  ^    ^  ^  ^
#      |  |  |     |  |  |    |  |  |
#                   .....
#
#  Each continent have an instance of a Index node that connects it to the world, it is defined by the following line:
#
#    child_nodes :continents
#
#  The index nodes are created when the root element is saved.
#
module IndexTree
  module NodeElement
    extend ActiveSupport::Concern

    included do
      has_one :index_tree_index_node, :class_name => 'IndexTree::IndexNode', as: :node_element

      # Creates index node for current tree node, and invokes index node creation for each defined association
      # @param [root_element] Id of the root
      def create_index_node(root_element)
        IndexTree::IndexNode.create!(:root_element => root_element, :node_element => self)
        create_index_nodes_for_children(root_element)
      end

      private

      class_attribute :child_nodes

      # Default value
      self.child_nodes = {}

      # Define what associations are child nodes
      # It will be used to create Index nodes when the root element will be saved
      # @param [*attributes] list of associations
      def self.child_nodes(*attributes)
        self.child_nodes = valid_associations(attributes)
      end

      def self.valid_associations(attributes)
        valid_associations = {}

        # Check if the declared input is an existing association
        Array(attributes).each do |association_name|
          valid_associations[association_name] = reflections[association_name] if reflections[association_name]
        end

        return valid_associations
      end

      # Invoke index node creation for children
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