$TOFU_ENV = 'test'

require File.dirname(__FILE__) + '/../tofu'
require 'ramaze/spec/helper'
require "rubygems"  
require "mocha/standalone"  
require "mocha/object"  

class Bacon::Context  
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

