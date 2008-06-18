require File.dirname(__FILE__) + '/../spec_helper'

describe 'Blocks Controller' do

  before do
    @controller = BlocksController.new
    @controller.stubs(:redirect).returns(nil)

    @request = mock()
    @controller.stubs(:request).returns(@request)
  end

  it "should get a dataset of blocks" do
    Block.create(:mold => 'Post', :content => { 'Title' => 'test', 'Body' => 'test' })
    
    @controller.get
    @controller.assigns(:blocks).should.be.kind_of Sequel::Dataset
    @controller.assigns(:blocks).each do |block|
      block.should.be.kind_of Block
    end

    Block.delete_all
  end

  it "should create a new block on post" do
    lambda {
      @request.expects(:params).at_least_once.returns({ 'block' => {
                                                          'mold' => 'Post',
                                                          'Title' => 'A test title',
                                                          'Body' => 'Some body content'
                                                        }})
      @controller.post
    }.should.change { Block.count }
  end
  
end
