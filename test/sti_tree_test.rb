require 'base_test'

class StiEquation < ActiveRecord::Base
  acts_as_indexed_node :root => true do
    belongs_to :sti_expression
  end

  def traverse
    sti_expression.traverse
  end
end

class StiExpression < ActiveRecord::Base
  belongs_to :sti_expression

  acts_as_indexed_node do
    has_many :sti_expressions
  end

  def traverse
    sti_expressions.map(&:traverse)
  end
end

class AExpression < StiExpression
end
class BExpression < StiExpression
end
class CExpression < StiExpression
end
class DExpression < StiExpression
end


class StiTreeTest < MiniTest::Unit::TestCase

  def setup
    setup_db

    expression1 = AExpression.create!
    expression2 = BExpression.create!(sti_expression: expression1)
    expression3 = CExpression.create!(sti_expression: expression1)
    expression4 = DExpression.create!(sti_expression: expression2)
    expression5 = AExpression.create!(sti_expression: expression2)
    expression6 = BExpression.create!(sti_expression: expression4)
    expression7 = CExpression.create!(sti_expression: expression4)
    expression8 = DExpression.create!(sti_expression: expression5)

    root = StiEquation.create!(sti_expression: expression1)
  end

  def teardown
    teardown_db
  end

  def test_preload_tree
    preload_tree(StiEquation,9)
  end
end
