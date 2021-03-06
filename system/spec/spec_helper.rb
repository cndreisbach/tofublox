ENV['RACK_ENV'] = 'test'

require File.dirname(__FILE__) + '/../tofu'
require "mocha/standalone"  
require "mocha/object"  
require 'bacon' unless defined?(Bacon)

Tofu.molds['TestMold'] = Mold.new('TestMold',
                                  [ ['Title', 'string'],
                                    ['Teaser', 'text'],
                                    ['Body', 'simple_text'],
                                    ['StringField', 'string'],
                                    ['TextField', 'text'],
                                    ['MarkdownField', 'markdown']
                                  ], '#{f :Teaser}', '#{f :Body}')

module SpecFactory
  def new_block(options = { })
    default_options = {
      :mold => 'TestMold',
      :author => 'Powerfist',
      :content => { 'Title' => 'test', 'Body' => 'test' },
      :published => true
    }
    Block.new(default_options.merge(options))
  end

  def create_block(*opts)
    new_block(*opts).save
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
