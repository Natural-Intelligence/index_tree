module IndexTree
  module ActsAsTreeNode
    def acts_as_tree_node(options={}, &block)
      if options[:root]
        include IndexTree::RootElement
        # yield if block_given?
      else
        include IndexTree::NodeElement
      end
    end
  end
end