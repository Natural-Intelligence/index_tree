module IndexTree
  module TreePreloader
    def self.preload_entities(root_entities)

      root_entities_array = Array(root_entities)
      root_entity_class = root_entities_array.first.class

      cache = {root_entity_class =>
                   Hash[root_entities_array.map { |t| [t.id, t] }]}

      tree_structure = root_entity_class.tree_structure

      tree_structure.each do |source_class, target_classes|
        target_classes.each do |target_class, load_instruction|
          preload_class(cache, root_entity_class, source_class)
          preload_class(cache, root_entity_class, target_class)

          if load_instruction[:opposite]
            associate_entities_opposite(cache, source_class, load_instruction[:association_name], target_class, load_instruction[:many])
          else
            associate_entities(cache, source_class, load_instruction[:association_name], target_class, load_instruction[:polymorphic])
          end
        end
      end

      return root_entities
    end

    def self.preload_class(cache, root_entity_class, class_to_load)
      unless cache.has_key?(class_to_load)
        cache[class_to_load] = Hash[class_to_load.joins(:index_tree_index_node)
                                                  .where(:index_tree_index_nodes => {:root_element_type => root_entity_class,
                                                                                    :root_element_id => cache[root_entity_class].keys})
                                                  .all.map { |t| [t.id, t] }]
      end
    end

    def self.associate_entities(cache, source_class, association_name, target_class, is_polymorphic)
      cache[source_class].values.each do |source_entity|
        if (is_polymorphic)
          parent_type = source_entity.send(association_name.to_s + '_type')
          next unless  parent_type == target_class.to_s
        end

        parent_id = source_entity.send(association_name.to_s + '_id')
        source_entity.association(association_name).target = cache[target_class][parent_id]
        source_entity.association(association_name).loaded!
      end
    end

    def self.associate_entities_opposite(cache, source_class, association_name, target_class, many)
      cache[target_class].values.each do |target_entity|
        attr_name = source_class.model_name.element + '_id'
        parent_id = target_entity.send(attr_name)
        if (parent_id)
          if (many)
            cache[source_class][parent_id].association(association_name).target << target_entity
          else
            cache[source_class][parent_id].association(association_name).target = target_entity
          end
        end
      end

      cache[source_class].values.each do |source_entity|
        source_entity.association(association_name).loaded!
      end
    end

  end
end
