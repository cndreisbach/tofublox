require 'rubygems'
require 'rack'
require 'camping'

require File.dirname(__FILE__) + '/system/tofu.rb'

Tofu::Models::Base.establish_connection(:adapter => 'sqlite3',
                                        :database => 'tofu.sqlite3')
Tofu::Models::Base.logger = Logger.new('tofu.log')
Tofu.create

run Rack::Adapter::Camping.new(Tofu)
