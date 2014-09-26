# Defines the ActsAssTreeNode Method
module IndexTree
  class Railtie < Rails::Railtie
    ActiveSupport.on_load(:active_record) do
      extend IndexTree::ActsAsTreeNode
    end
  end
end