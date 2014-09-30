require 'minitest/autorun'
require 'minitest/benchmark'
require 'active_record'
require 'rails'
require 'index_tree'

require 'simplecov'
require 'coveralls'
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter '/test/'
  add_filter '/vendor/'
end

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

class MiniTest::Unit::TestCase
  def assert_queries(num = 1, &block)
    query_count, result = count_queries(&block)
    result
  ensure
    assert_equal num, query_count, "#{query_count} instead of #{num} queries were executed."
  end

  def assert_no_queries(&block)
    assert_queries(0, &block)
  end

  def count_queries &block
    count = 0

    counter_f = ->(name, started, finished, unique_id, payload) {
      unless %w[ CACHE SCHEMA ].include? payload[:name]
        count += 1
      end
    }

    result = ActiveSupport::Notifications.subscribed(counter_f, "sql.active_record", &block)

    [count, result]
  end
end


def setup_db
  ActiveRecord::Schema.define(version: 1) do
    create_table :index_tree_index_nodes do |t|
      t.integer :root_element_id, null: false
      t.string :root_element_type, null: false
      t.integer :node_element_id, null: false
      t.string :node_element_type, null: false
      t.datetime :created_at
      t.datetime :updated_at
    end


    create_table :equations do |t|
      t.references :expression
    end

    create_table :expressions do |t|
      t.references :expression
    end

    create_table :poly_equations do |t|
      t.references :poly_expression
    end

    create_table :expression_containers do |t|
      t.references :poly_expression
      t.references :base_expression, polymorphic: true
    end

    create_table :poly_expressions do |t|
    end

    create_table :values do |t|
    end

    create_table :sti_equations do |t|
      t.references :sti_expression
    end

    create_table :sti_expressions do |t|
      t.string :type, null: false
      t.references :sti_expression
    end
  end

end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

def preload_tree(class_to_test,num_of_queries)
  not_load = class_to_test.first
  assert_queries(num_of_queries) do
    not_load.traverse
  end

  loaded = class_to_test.first.preload_tree
  assert_no_queries do
    loaded.traverse
  end
end

