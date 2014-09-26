# Adds a preload_tree method to the model
# Usage example:
#
#     Model.find(1).preload_tree
#
module IndexTree
  module FinderMethods
    extend ActiveSupport::Concern

    included do
      def preload_tree
        return IndexTree::TreePreloader.preload_entities(self)
      end

    end
  end
end


# Add a preload_tree method to the ActiveRecord_Relation
# Usage example:
#
#     Model.where(level: 2).all.preload_tree
#     Model.all.preload_tree
#
module ActiveRecord
  class Relation
    def preload_tree
      load unless loaded?
      return IndexTree::TreePreloader.preload_entities(@records)
    end
  end
end
