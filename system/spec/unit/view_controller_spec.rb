require File.dirname(__FILE__) + '/../spec_helper'

describe 'View Controller' do

  behaves_like 'controller spec'

  it "should retrieve a block" do
    block = create_block    
    @controller.get(block.permalink)
    @controller.assigns(:block).should.not.be.nil
  end

  it "should raise NotFound if block not found" do
    lambda { 
      @controller.get(-1)
    }.should.raise Tofu::Errors::NotFound
  end

end
