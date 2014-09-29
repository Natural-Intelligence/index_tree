# Defines the ActsAsIndexedNode Method
module IndexTree
  class Railtie < Rails::Railtie
    ActiveSupport.on_load(:active_record) do
      extend IndexTree::ActsAsIndexedNode
    end
  end
end
