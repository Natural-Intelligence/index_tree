require 'active_support/concern'

# Defines the root element of the tree, it invokes the recursive index nodes creation.
# And Holds the structure of the tree
module IndexTree
  module RootElement
    extend ActiveSupport::Concern
    include IndexTree::FinderMethods
    include IndexTree::NodeElement

    included do
      has_many :index_tree_index_nodes, :class_name => 'IndexTree::IndexNode', as: :root_element, dependent: :destroy

      after_save :rebuild_index_nodes

      private
      # Will rebuild the index nodes for the decision tree of the Root element
      # It will be used in the eager load for fetching only the data that is related to the current Root Element
      def rebuild_index_nodes
        # Delete all old indices
        IndexTree::IndexNode.delete_all({:root_element => self})

        # Creates index node for the current tree node, and invokes recursive call for the children of the node
        create_index_nodes_for_children(self)
      end

      # @return [tree_structure] Each Root Element hold the structure of the tree
      def self.tree_structure
        @@tree_structure ||= {}
        @@tree_structure[self] ||= create_tree_structure({}, self)
      end

      # Recursive function that create the structure of the tree
      # Iterates each tree node relation and creates a loading instruction
      # @param [loaded_associations] Previous associations
      # @param [class_to_load] Current class association
      def self.create_tree_structure(loaded_associations, class_to_load)
        class_to_load.child_nodes.each do |association_name, association|
          get_all_child_classes(association).each do |child_class|

            if (loaded_associations[class_to_load].nil? || loaded_associations[class_to_load][child_class].nil?)
              loaded_associations[class_to_load] ||= {}

              if association.macro == :belongs_to
                loaded_associations[class_to_load][child_class] = {many: false, opposite: false, association_name: association_name, polymorphic: association.polymorphic?}
              elsif association.macro == :has_one
                loaded_associations[class_to_load][child_class] = {many: false, opposite: true, association_name: association_name, polymorphic: association.polymorphic? }
              elsif association.macro == :has_many
                loaded_associations[class_to_load][child_class] = {many: true, opposite: true, association_name: association_name, polymorphic: association.polymorphic?}
              end

              create_tree_structure(loaded_associations, child_class)
            end
          end
        end

        return loaded_associations
      end

      # Return all the classes for current association
      # @param [association]
      def self.get_all_child_classes(association)
        if (association.polymorphic?)
          return find_all_polymorphic_classes(association.name)
        else
          return Array(association.klass)
        end
      end

      # Find all the classes from the polymorphic type
      # @param [polymorphic_class] type to find
      def self.find_all_polymorphic_classes(polymorphic_class)
        ret = []
        ObjectSpace.each_object(Class).select { |klass| klass < ActiveRecord::Base }.each do |i|
          unless i.reflect_on_all_associations.select { |j| j.options[:as] == polymorphic_class }.empty?
            ret << i
          end
        end
        ret.flatten
      end
    end
  end
end
