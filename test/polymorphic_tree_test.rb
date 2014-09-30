require 'base_test'

class PolyEquation < ActiveRecord::Base
  acts_as_indexed_node :root => true do
    belongs_to :poly_expression
  end

  def traverse
    poly_expression.traverse
  end
end

class ExpressionContainer < ActiveRecord::Base
  belongs_to :poly_expression

  acts_as_indexed_node do
    belongs_to :base_expression, polymorphic: true
  end

  def traverse
    base_expression.traverse
  end
end

class PolyExpression < ActiveRecord::Base
  acts_as_indexed_node do
    has_many :expression_containers
  end

  has_one :expression_container, as: :base_expression

  def traverse
    expression_containers.map(&:traverse)
  end
end

class Value < ActiveRecord::Base
  acts_as_indexed_node

  has_one :expression_container, as: :base_expression

  def traverse
  end
end

class PolymorphicTreeTest < MiniTest::Unit::TestCase

  def setup
    # teardown_db
    setup_db

    value1 = Value.create!()
    value2 = Value.create!()
    value3 = Value.create!()
    value4 = Value.create!()

    expression1 = PolyExpression.create!()
    ExpressionContainer.create!(poly_expression: expression1, base_expression: value1)
    ExpressionContainer.create!(poly_expression: expression1, base_expression: value2)

    expression2 = PolyExpression.create!()
    ExpressionContainer.create!(poly_expression: expression2, base_expression: value3)
    ExpressionContainer.create!(poly_expression: expression2, base_expression: value4)
    ExpressionContainer.create!(poly_expression: expression2, base_expression: expression1)
    ExpressionContainer.create!(poly_expression: expression2, base_expression: expression1)

    PolyEquation.create!(poly_expression: expression2)
  end

  def teardown
    teardown_db
  end

  def test_preload_tree
    preload_tree(PolyEquation,12)
    # not_load_equation = PolyEquation.first
    #
    # assert_queries(12) do
    #   not_load_equation.traverse
    # end
    #
    # load_equation = PolyEquation.first.preload_tree
    #
    # assert_no_queries do
    #   load_equation.traverse
    # end
  end
end
