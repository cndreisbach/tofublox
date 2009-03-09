require File.dirname(__FILE__) + '/../spec_helper'

describe 'a new Block' do
  before do
    @block = Block.new
  end
  
  it "should not be valid" do
    @block.should.not.be.valid
    @block.errors[:mold].should.not.be.nil
    @block.errors[:content].should.not.be.nil
  end

  it "should have an empty hash as content" do
    @block.content.should == { }
  end
end

describe 'a Block' do
  before do
    @block = new_block
  end

  after do
    Block.delete_all
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
    Time.expects(:now).at_least_once.returns(now + 2)
    @block.save
    @block.created_at.should.not == @block.altered_at
    @block.created_at.should < now
    @block.altered_at.should >= now
  end

  it "should serialize content to YAML" do
    test_content = { 'Name' => 'Clinton', 'Title' => 'test' }
    @block.content = test_content
    @block.permalink = nil
    @block.save
    test_yaml = Tofu.db[:blocks][:id => @block.id][:content]
    test_yaml.should == test_content.to_yaml
  end

  it "should have mold object" do
    @block.mold = 'Post'
    @block.mold.should.be.instance_of Mold
    @block.mold.should == Tofu.molds['Post']
  end

  it "should use its mold's body for string representation" do
    mold = mock()
    mold.stubs(:body).returns('Hello #{f :name}')
    mold.stubs(:filename).returns('/etc/passwd')
    mold.stubs(:formatters).returns({ 'name' => Tofu::Formatters::String })
    @block.stubs(:mold).returns(mold)
    
    @block.content['name'] = 'world'
    @block.to_s.should == 'Hello world'
  end

  it "should have a title attribute" do
    @block.content['title'] = 'This is a sample title'
    @block.title.should == 'This is a sample title'

    @block.content.delete('title')
    @block.content['Title'] = 'This is another title'
    @block.title.should == 'This is another title'
  end

  it "should pick the most appropriate piece of content for a title" do
    @block.content['title'] = 'lowercase'
    @block.content['Title'] = 'Uppercase'

    @block.title.should == 'lowercase'
  end

  it "should have a unique permalink" do
    block1 = new_block(:permalink => 'test')
    block1.save.should.not.be.nil

    block2 = new_block(:permalink => 'test')
    block2.should.not.be.valid
    block2.errors[:permalink].should.not.be.nil
  end

  it "should generate a permalink before save if empty" do
    @block[:content]
    @block.permalink = nil
    @block.save

    @block.permalink.should == @block.title.slugify
  end

  it "should generate a permalink from title if it exists" do
    @block.content['title'] = 'This post is about UFOs'
    @block.send(:set_permalink)
    @block.permalink.should.be == 'this-post-is-about-ufos'
  end

  it "should generate a permalink from the datetime if there is no title" do
    now = Time.now
    Time.stubs(:now).at_least_once.returns(now)

    @block.stubs(:title).returns(nil)

    @block.send(:set_permalink)
    @block.permalink.should == Time.now.strftime("%Y%m%d%H%M")
  end

  it "should try again to generate a permalink if they collide" do
    @block.content['Title'] = 'test'
    @block.save

    @block = new_block
    @block.content['Title'] = 'test'
    @block.save
    @block.errors[:permalink].should == []

    @block.permalink.should.match /test-\d\d/
  end

  it "should update its content" do
    @block.update_content('Title' => 'Updated!')
    @block.field(:Title).should == 'Updated!'
  end
  
  it "should be able to be published and unpublished" do
    now = Time.now
    Time.stubs(:now).at_least_once.returns(now)
    
    @block.published = false
    @block.should.not.be.published
    @block.published = true
    @block.should.be.published
    @block.published_at.should == now
  end
  
end

  
