require 'polymorphic_tree_test'
require 'sti_tree_test'
require 'simple_tree_test'

class MultipleTreeTypesTest < MiniTest::Unit::TestCase

  def setup
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

    expression1 = AExpression.create!
    expression2 = BExpression.create!(sti_expression: expression1)
    expression3 = CExpression.create!(sti_expression: expression1)
    expression4 = DExpression.create!(sti_expression: expression2)
    expression5 = AExpression.create!(sti_expression: expression2)
    expression6 = BExpression.create!(sti_expression: expression4)
    expression7 = CExpression.create!(sti_expression: expression4)
    expression8 = DExpression.create!(sti_expression: expression5)

    sti_root = StiEquation.create!(sti_expression: expression1)
  end

  def teardown
    teardown_db
  end

  def test_preload_multiple_tree_types
    preload_tree([StiEquation, Equation], 18)
  end
end
