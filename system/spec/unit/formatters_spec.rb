require File.dirname(__FILE__) + '/../spec_helper'

describe 'a String formatter' do
  before do
    @text = "some text\n\nand more text"
    @block = new_block(:content => { 'StringField' => @text })
  end

  it "should render as its own text" do
    @block.field('StringField').should == @text
  end
end

describe 'a Text formatter' do
  before do
    @text = "some text\n\nand more text"
    @block = new_block(:content => { 'TextField' => @text })
  end

  it "should render as HTML formatted text" do
    @block.field('TextField').should == "<p>some text</p>\n\n<p>and more text</p>"
  end
end

describe 'a Markdown formatter' do
  require 'maruku'
  
  before do
    @text = <<EOF
# A header

some text

* these
* _are_
* bullet points
EOF
    @block = new_block(:content => { 'MarkdownField' => @text })
  end

  it "should render as Markdown text converted to HTML" do
    @block.field('MarkdownField').should == Maruku.new(@text).to_html
  end
end

