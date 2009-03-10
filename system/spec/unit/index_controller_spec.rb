require File.dirname(__FILE__) + '/../spec_helper'

describe 'Index Controller' do

  behaves_like 'controller spec'
  
  it "should get a dataset of blocks" do
    create_block
    
    @controller.get
    @controller.assigns(:blocks).should.be.kind_of Sequel::Dataset
    @controller.assigns(:blocks).count.should > 0
    @controller.assigns(:blocks).each do |block|
      block.should.be.kind_of Block
    end

    Block.delete
  end
  
  it "should only get published blocks" do
    block = create_block(:published => false)
    
    @controller.get
    @controller.assigns(:blocks).count.should == 0
    
    block.published = true
    block.save
    
    @controller.get
    @controller.assigns(:blocks).count.should == 1
  
    Block.delete    
  end
end
