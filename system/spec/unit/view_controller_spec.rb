require File.dirname(__FILE__) + '/../spec_helper'

describe 'View Controller' do

  behaves_like 'controller spec'

  it "should retrieve a block" do
    block = create_block    
    @controller.get(block.permalink)
    @controller.assigns(:block).should.not.be.nil
  end

end
