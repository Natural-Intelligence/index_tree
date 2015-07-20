#!/bin/bash

#get path param
path=$1

#select ruby version
source /usr/local/rvm/scripts/rvm
rvm use 2.1.2

cd $path

#run unit tests
bundle install
bundle exec rake test
