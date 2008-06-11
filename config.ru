require 'rubygems'
require 'rack'
require 'camping'

require File.dirname(__FILE__) + '/system/tofu.rb'

run Rack::Adapter::Camping.new(Tofu)
