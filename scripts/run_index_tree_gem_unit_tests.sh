#!/bin/bash

#get path param
path=$1
echo path: $path

#select ruby version
source /usr/local/rvm/scripts/rvm
rvm use 2.1.2
cd $path

echo "###########################"
#run unit tests
bundle install
bundle exec rake test
