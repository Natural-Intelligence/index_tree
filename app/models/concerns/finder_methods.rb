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

module ActiveRecord
  class Relation
    def preload_tree
      load unless loaded?
      return IndexTree::TreePreloader.preload_entities(@records)
    end
  end
end
