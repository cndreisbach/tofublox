#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/system/tofu'
Ramaze.start :adapter => :mongrel, :port => 7000

