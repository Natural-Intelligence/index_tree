require "bundler/gem_tasks"

desc "Run unit tests."
task :test do
  $: << "test"
  Dir["test/*_test.rb"].each { |f| require f[5..-4] }
end

task :default => :test

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  require "index_tree/version"
  version = IndexTree::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "index_tree #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end