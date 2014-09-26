module IndexTree
  class IndexNode < ActiveRecord::Base
    belongs_to :root_element, polymorphic: true
    belongs_to :node_element, polymorphic: true
  end
end
