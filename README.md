# IndexTree

This Gem eager loads trees by indexing the nodes of the tree. The number of queries needed to load a tree is N, 
when N is the number of different models(ActiveRecords) in the tree.

Each inner object in the tree have an index node instance that is connecting it to the root.
When the root of the tree is loaded, only the objects that are in the tree are fetched(Pruning).
The index nodes are created when the root element is saved.

Example:

    class Equation
        acts_as_indexed_node :root => true do
            has_many :expressions
        end
      
        has_one :not_tree_association_a
    end
    
    
    class Expression
        acts_as_indexed_node do
            has_many :expressions
        end
        
        has_one :not_tree_association_b
    end
        
                     +----------+                                         +----------+
                     |Equation 1|                                         |Equation 2|
                     +-+------+-+                                         +-+------+-+
                       |      |                                             |      |
               +-------+      +-------+                             +-------+      +-------+
               |                      |                             |                      |
               v                      v                             v                      v
         +-----------+          +-----------+                 +-----------+          +-----------+
         |Expression1|          |Expression2|                 |Expression5|          |Expression6|
         +-----------+          +-+-------+-+                 +-----------+          +-+-------+-+
                                  |       |                                            |       |
                          +-------+       +-------+                            +-------+       +-------+
                          |                       |                            |                       |
                          v                       v                            v                       v
                    +-----------+           +-----------+                +-----------+           +-----------+
                    |Expression3|           |Expression4|                |Expression7|           |Expression8|
                    +-----------+           +-----------+                +-----------+           +-----------+
    
The following statement fetches only the objects in the Equation1 tree in two queries:    
      
    Equation.find(1).preload_tree
    
One query to fetch Equations, and the second query is to fetch Expressions(Doesn't matter how deep is the tree it is still one query)
    

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'index_tree'
```

And then execute:

    $ bundle
    $ rake db:migrate 
    
There is a migration which creates index_tree_index_node table

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
