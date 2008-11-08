require File.dirname(__FILE__) + '/../spec_helper'

describe 'Block Controller' do

  behaves_like 'controller spec'

  it "should retrieve a block" do
    block = create_block    
    @controller.get(block.permalink)
    @controller.assigns(:block).should.not.be.nil
  end

  it "should return a 404 if block not found" do
    @controller.expects(:respond).with('That block was not found.', 404)
    @controller.get(-1).should == nil
  end

  it "should update a block" do
    block = create_block
    @request.expects(:params).at_least_once.returns({ 'block' => {
                                                        'mold' => 'Post',
                                                        'Title' => 'Updated title',
                                                        'Body' => 'Updated content'
                                                      }})
    @controller.put(block.permalink)

    @controller.assigns(:block).field('Title').should == 'Updated title'
  end

end
