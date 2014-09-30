# Defines the ActsAsIndexedNode Method
class IndexTree::Railtie < Rails::Railtie
  ActiveSupport.on_load(:active_record) do
    extend IndexTree::ActsAsIndexedNode
  end
end

