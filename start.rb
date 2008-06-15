#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/system/tofu'

class MainController < Ramaze::Controller
  def index
    "Hi"
  end
end

Ramaze.start :adapter => :webrick, :port => 7000
