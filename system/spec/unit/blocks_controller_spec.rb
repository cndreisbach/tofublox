require File.dirname(__FILE__) + '/../spec_helper'

describe 'Blocks Controller' do

  behaves_like 'controller spec'
  
  it "should get a dataset of blocks" do
    create_block
    
    @controller.get
    @controller.assigns(:blocks).should.be.kind_of Sequel::Dataset
    @controller.assigns(:blocks).each do |block|
      block.should.be.kind_of Block
    end

    Block.delete
  end

  it "should create a new block on post" do
    lambda {
      @request.expects(:params).at_least_once.returns({ 'block' => {
                                                          'mold' => 'Post',
                                                          'author' => 'Kraator',
                                                          'Title' => 'A test title',
                                                          'Body' => 'Some body content'
                                                        }})
      @controller.post
    }.should.change { Block.count }
  end
  
end
