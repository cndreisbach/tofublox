ENV['RACK_ENV'] = 'test'

require File.dirname(__FILE__) + '/../tofu'
require 'ramaze/spec/helper'
require "rubygems"  
require "mocha/standalone"  
require "mocha/object"  

module SpecFactory
  def create_block(options = { })
    default_options = {
      :mold => 'Post',
      :content => { 'Title' => 'test', 'Body' => 'test' }
    }
    Block.create(default_options.merge(options))
  end
end

class Bacon::Context
  include SpecFactory
  
  include Mocha::Standalone  
  alias_method :old_it,:it  

  def it description,&block  
    mocha_setup  
    old_it(description,&block)  
    mocha_verify  
    mocha_teardown  
  end  
end  

class Ramaze::Controller
  def assigns(var_name)
    instance_variable_get("@#{var_name}")
  end
end

shared("controller spec") do
  before do
    @controller = @name.gsub(/\s+/, '').constantize.new
    @controller.stubs(:redirect).returns(nil)
    @request = mock()
    @controller.stubs(:request).returns(@request)
  end
end
