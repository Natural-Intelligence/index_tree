[![Build Status](https://secure.travis-ci.org//Natural-Intelligence/index_tree.svg?branch=master)](https://travis-ci.org/Natural-Intelligence/index\_tree)
[![Coverage Status](https://coveralls.io/repos/AlexStanovsky/index_tree/badge.png?branch=master)](https://coveralls.io/r/AlexStanovsky/index_tree?branch=master)
# IndexTree

This Gem eager loads trees by indexing the nodes of the tree. The number of queries needed to load a tree is N, 
when N is the number of different models(ActiveRecords) in the tree.

Each inner object in the tree have an index node instance that is connecting it to the root.
When the root of the tree is loaded, only the objects that are in the tree are fetched(Pruning).
The index nodes are created when the root element is saved and stored in the IndexNode model.

## Example:
### Models definitions:
    class Equation < ActiveRecord::Base
        acts_as_indexed_node :root => true do
            has_many :expressions
        end
      
        has_one :not_tree_association_a
        
        def traverse
           expression.traverse
        end        
    end
    
    
    class Expression < ActiveRecord::Base
        belongs_to :equation, inverse_of: :expressions
        
        acts_as_indexed_node do
            has_many :expressions
        end
        
        has_one :not_tree_association_b
        
        def traverse
            expressions.map(&:traverse)
        end
    end
    
### Database initialization: 
        
                     +-----------+                               +-----------+
                     |Equation  1|                               |Equation  2|
                     +-----+-----+                               +-----+-----+
                           |                                           |
                           v                                           v
                     +-----------+                               +-----------+
                     |Expression1|                               |Expression6|
                     +-+-------+-+                               +-+-------+-+
                       ^       ^                                   ^       ^
                       |       |                                   |       |
               +-------+       +-------+                   +-------+       +-------+
               |                       |                   |                       |
               |                       |                   |                       |
         +-----+-----+           +-----+-----+       +-----+-----+           +-----+-----+
         |Expression3|           |Expression2|       |Expression8|           |Expression7|
         +-----------+           +-----------+       +-----------+           +-----------+
                                   ^       ^                                   ^       ^
                                   |       |                                   |       |
                           +-------+       +-------+                   +-------+       +-------+
                           |                       |                   |                       |
                           |                       |                   |                       |
                     +-----+-----+           +-----+-----+       +-----+-----+          +------+-----+
                     |Expression4|           |Expression5|       |Expression9|          |Expression10|
                     +-----------+           +-----------+       +-----------+          +------------+                       
    
### Traversal example without tree pre-loading:
   
    Equation.find(1).traverse
    
Those are the queries that is executed:

    Equation Load (0.2ms)  SELECT  "equations".* FROM "equations"   ORDER BY "equations"."id" ASC LIMIT 1
    Expression Load (0.2ms)  SELECT  "expressions".* FROM "expressions"  WHERE "expressions"."id" = ? LIMIT 1  [["id", 1]]
    Expression Load (0.1ms)  SELECT "expressions".* FROM "expressions"  WHERE "expressions"."expression_id" = ?  [["expression_id", 1]]
    Expression Load (0.1ms)  SELECT "expressions".* FROM "expressions"  WHERE "expressions"."expression_id" = ?  [["expression_id", 2]]
    Expression Load (0.1ms)  SELECT "expressions".* FROM "expressions"  WHERE "expressions"."expression_id" = ?  [["expression_id", 4]]
    Expression Load (0.1ms)  SELECT "expressions".* FROM "expressions"  WHERE "expressions"."expression_id" = ?  [["expression_id", 5]]
    Expression Load (0.1ms)  SELECT "expressions".* FROM "expressions"  WHERE "expressions"."expression_id" = ?  [["expression_id", 3]]

It can be improved with eager loading such as 'includes', but eager loading will be fixed to the tree height.

### Traversal example with tree pre-loading:
            
    Equation.find(1).preload_tree.traverse

The statement fetches only the objects in the Equation1 tree in two queries:    
       
    Equation Load (0.1ms)  SELECT  "equations".* FROM "equations"   ORDER BY "equations"."id" ASC LIMIT 1
    Expression Load (0.2ms)  SELECT "expressions".* FROM "expressions" 
    INNER JOIN "index_tree_index_nodes" ON "index_tree_index_nodes"."node_element_id" = "expressions"."id" 
    AND "index_tree_index_nodes"."node_element_type" = 'Expression' 
    WHERE "index_tree_index_nodes"."root_element_type" = 'Equation' AND "index_tree_index_nodes"."root_element_id" IN (1)
    
One query to fetch Equations, and the second query is to fetch Expressions(Doesn't matter how deep is the tree it is still one query)
    

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'index_tree'
```

And then execute:

    $ bundle
    $ rake db:migrate 
    
There is a migration which creates index_tree_index_node table(IndexNode model)

## Declaration

All the models should be loaded in the Rails application, before using the preload_tree.

    class RootNode < ActiveRecord::Base
       acts_as_indexed_node :root => true do
         has_many :child_nodes, dependent: :destroy
       end
    end
    
### The following associations are supported:
 
     belongs_to
     belongs_to :class, polymorphic: true
     has_one
     has_many

### The following types of inheritance are supported:
    
    STI 
    Polymorphic associations
    
### Options:

    :root   Used to declare a root model(default is false)
        
## Usage

    RootModel.find(1).preload_tree
    RootModel.all.preload_tree
    RootModel.where(color: 'red').all.preload_tree
