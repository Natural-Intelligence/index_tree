#!/bin/bash

source /usr/local/rvm/scripts/rvm
rvm use 2.1.2
cd /var/jenkins_home/jobs/index_tree_gem_unit_tests/workspace/

#run unit tests
bundle install
bundle exec rake test
