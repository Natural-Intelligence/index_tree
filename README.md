# IndexTree

This Gem eager loads trees by indexing the nodes of the tree. The number of queries needed to load a tree is N+1, 
when N is number of different models(ActiveRecords) in the tree.

Each inner object in the tree have an index node instance that is connecting it to the root.
When the root of the tree is loaded, only the objects that are in the tree are fetched(Pruning).

Example:

    class continents
      include IndexTree::RootElement

       has_many :logical_expressions

       child_nodes :logical_expressions
    end

     ========         ========         ========
     | Asia |         |Africa|         |Europe|
     ========         ========         ========
     ^      ^         ^      ^         ^      ^
     |      |         |      |         |      |

                       
                       

The index nodes are created when the root element is saved.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'index-tree'
```

And then execute:

    $ bundle
    $ rake db:migrate (Migration which creates index_tree_index_node table)

## Declaration

All the models should be load in the application, before using the preload_tree.

    class RootNode < ActiveRecord::Base
       acts_as_tree_node :root => true do
         has_many :child_nodes, dependent: :destroy
       end
    end
    
The following associations are supported:
 
     belongs_to
     belongs_to :class, polymorphic: true
     has_one
     has_many

The following types of inheritance are supported:
    STI
    Polymorphic associations
    
## Options

    :root   Used to declare a root model(default is false)
        
## Usage

    RootModel.find(1).preload_tree
    RootModel.all.preload_tree
    RootModel.where(color: 'red').all.preload_tree
