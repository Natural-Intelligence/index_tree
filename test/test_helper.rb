require 'minitest/autorun'
require 'minitest/benchmark'
require 'active_record'
require 'rails'
require 'index_tree'

require 'minitest/reporters'
MiniTest::Reporters.use! [MiniTest::Reporters::DefaultReporter.new,
                          MiniTest::Reporters::JUnitReporter.new]

require 'simplecov'
require 'simplecov-rcov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::RcovFormatter,
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter 'test/'
  add_filter 'db/'
end

Dir["test/*_test.rb"].each { |f| require f[5..-4] }