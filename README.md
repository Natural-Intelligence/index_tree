# IndexTree

This Gem eager loads trees by indexing the nodes of the tree.
Each inner object in the tree have an index node instance that is connecting it to the root.
It is used in eager load of Root element, for fetching only the objects that are in the tree of a specific root(Pruning).
Each of the nodes in the tree should have one of the following declarations:

    include IndexTree::RootElement - for root element
    include IndexTree::NodeElement - for node elements

And declare what associations are used to define the relations of the tree.
Usage:

     child_nodes :name_of_exisiting_association

Example:

    class calculation
      include IndexTree::RootElement

       has_many :logical_expressions

       child_nodes :logical_expressions
    end

     ========         ========         ========
     | Asia |         |Africa|         |Europe|
     ========         ========         ========
     ^      ^         ^      ^         ^      ^
     |      |         |      |         |      |

                       
                       

Each continent have an instance of a Index node that connects it to the world, it is defined by the following line:

    child_nodes :continents

The index nodes are created when the root element is saved.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'index-tree'
```

And then execute:

    $ bundle
    $ rake index_tree_engine:install:migrations

## Usage

Support Associations:
    belongs_to
    belongs_to :class, polymorphic: true
    has_one
    has_many
    
All the model should be load in the application, before using the preload_tree

    RootModel.find(1).preload_tree
    RootModel.all.preload_tree
    RootModel.where(color: 'red').all.preload_tree
