require File.dirname(__FILE__) + '/../spec_helper'

describe 'a String field' do
  before do
    @text = "some text\n\nand more text"
    @block = new_block(:content => { 'StringField' => @text })
  end
  
  it "should render as its own text" do
    @block.field('StringField').to_s.should == @text
  end
end

describe 'a Text field' do
  before do
    @text = "some text\n\nand more text"
    @block = new_block(:content => { 'TextField' => @text })
  end

  it "should render as HTML formatted text" do
    @block.field('TextField').to_s.should == "<p>some text</p>\n\n<p>and more text</p>"
  end
end
  