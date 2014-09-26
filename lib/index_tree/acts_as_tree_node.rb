module IndexTree
  module ActsAsTreeNode
    def acts_as_tree_node(options={}, &block)
      if options[:root]
        include IndexTree::RootElement
      else
        include IndexTree::NodeElement
      end

      # Find what associations were defined in the given block
      # And set the child nodes
      if block_given?
        current_associations = reflections.keys
        yield
        associations_in_block = reflections.keys - current_associations
        child_nodes *associations_in_block
      end
    end
  end
end