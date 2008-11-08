require File.dirname(__FILE__) + '/../spec_helper'

describe 'Index Controller' do

  behaves_like 'controller spec'
  
  it "should get a dataset of blocks" do
    create_block
    
    @controller.get
    @controller.assigns(:blocks).should.be.kind_of Sequel::Dataset
    @controller.assigns(:blocks).each do |block|
      block.should.be.kind_of Block
    end

    Block.delete_all
  end

end
