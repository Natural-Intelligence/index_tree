require 'base_test'


class Equation < ActiveRecord::Base
  acts_as_indexed_node :root => true do
    has_one :expression, inverse_of: :equation
  end

  def traverse
    expression.traverse
  end
end

class Expression < ActiveRecord::Base
  belongs_to :equation, inverse_of: :expression
  belongs_to :expression

  acts_as_indexed_node do
    has_many :expressions
  end

  def traverse
    expressions.map(&:traverse)
  end
end

class SimpleTreeTest < MiniTest::Unit::TestCase

  def setup
    setup_db

    equation = Equation.create!()

    @expression1 = Expression.create!(equation: equation)
    expression2 = Expression.create!(expression: @expression1)
    expression3 = Expression.create!(expression: @expression1)
    expression4 = Expression.create!(expression: expression2)
    expression5 = Expression.create!(expression: expression2)
    expression6 = Expression.create!(expression: expression4)
    expression7 = Expression.create!(expression: expression4)
    expression8 = Expression.create!(expression: expression5)

    # Rebuild index tree
    equation.save
  end

  def teardown
    teardown_db
  end

  def test_preload_tree
    preload_tree(Equation, 9)
  end


  def test_preload_multi_tree
    not_load = Equation.all
    assert_queries(10) do
      not_load.map(&:traverse)
    end

    loaded = Equation.all.preload_tree
    assert_no_queries do
      loaded.map(&:traverse)
    end

  end

  def count_nodes(tree_node)
    num_of_nodes = 0

    tree_node.class.child_nodes.keys.each do |association_name|
      association_value = tree_node.send(association_name)

      Array(association_value).each do |child_node|
        num_of_nodes += count_nodes(child_node) + 1
      end
    end

    return num_of_nodes
  end

  def test_index_node_creation

    equation1 = Equation.first

    num_of_tree_nodes = count_nodes(equation1)
    assert_equal num_of_tree_nodes, equation1.index_tree_index_nodes.size, "#{num_of_tree_nodes} instead of #{equation1.index_tree_index_nodes.size} index node were created."
  end
end


