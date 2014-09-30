require 'base_test'


class Equation < ActiveRecord::Base
  acts_as_indexed_node :root => true do
    belongs_to :expression
  end

  def traverse
    expression.traverse
  end
end

class Expression < ActiveRecord::Base
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
    # teardown_db
    setup_db

    expression1 = Expression.create!
    expression2 = Expression.create!(expression: expression1)
    expression3 = Expression.create!(expression: expression1)
    expression4 = Expression.create!(expression: expression2)
    expression5 = Expression.create!(expression: expression2)
    expression6 = Expression.create!(expression: expression4)
    expression7 = Expression.create!(expression: expression4)
    expression8 = Expression.create!(expression: expression5)

    root = Equation.create!(expression: expression1)
  end

  def teardown
    teardown_db
  end

  def test_preload_tree
    preload_tree(Equation,9)
  end
end


