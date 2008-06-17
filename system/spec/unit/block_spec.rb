require File.dirname(__FILE__) + '/../spec_helper'

describe 'a Block' do
  before do
    @block = Block.new
  end
  
  it "should be valid" do
    @block.should.be.valid
  end

  it "should have an empty hash as content" do
    @block.content.should == { }
  end

  it "should retrieve content via field" do
    @block.content['test'] = :foo
    @block.field('test').should == :foo
    @block.field(:test).should == :foo
  end

  it "should save timestamps appropriately" do
    @block.save
    @block.created_at.should.not.be.nil
    @block.altered_at.should.not.be.nil
    @block.created_at.should == @block.altered_at

    now = Time.now + 1
    Time.expects(:now).returns(now + 2)
    @block.save
    @block.created_at.should.not == @block.altered_at
    @block.created_at.should < now
    @block.altered_at.should >= now
  end

  it "should serialize content to YAML" do
    test_content = { 'Name' => 'Clinton', 'Title' => 'test' }
    @block.content = test_content
    @block.save
    test_yaml = Tofu.db[:blocks][:id => @block.id][:content]
    test_yaml.should == test_content.to_yaml
  end

  it "should have mold object" do
    @block.mold = 'Post'
    @block.mold.should.be.instance_of Mold
    @block.mold.should == Tofu.molds['Post']
  end

  it "should use its mold's template for string representation" do
    mold = mock()
    mold.stubs(:template).returns('Hello #{f :name}')
    @block.stubs(:mold).returns(mold)
    
    @block.content['name'] = 'world'
    @block.to_s.should == 'Hello world'
  end
end

  
