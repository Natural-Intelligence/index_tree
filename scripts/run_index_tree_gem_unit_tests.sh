#!/bin/bash

#get path param
path=$1
echo path: $path

run_unit_tests(){
  bundle install
  bundle exec rake test
}

### main ###
cd $path
source /usr/local/rvm/scripts/rvm
rvm use 2.1.2
run_unit_tests
