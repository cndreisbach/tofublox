require File.dirname(__FILE__) + '/../spec_helper'

describe 'a Mold' do

  before do
    @fields = { 'URL' => 'string', 'Description' => 'text' }
    @template = '#{f :URL} // #{f :Description}'
    @mold = Mold.new('Bookmark', @fields, @template)
  end

  it "should have a name" do
    @mold.name.should == 'Bookmark'
  end

  it "should have a string representation" do
    @mold.to_s.should == 'Bookmark'
  end

  it "should have fields" do
    @mold.should.respond_to(:fields)
    @mold.fields.should == @fields
  end

  it "should have a template" do
    @mold.should.respond_to(:template)
    @mold.template.should == @template
  end
  
end


describe 'Mold class' do
  it "should define its file store in the user dir" do
    Mold.file_store.should == Tofu.dir('molds')
  end

  it "should be able to be created from a text format" do
    mold_text = %q[---
- URL: string
- Description: text
---
#{f :URL} // #{f :Description}]
    bookmark = Mold.from_activefile(mold_text, 'Bookmark')

    bookmark.fields.should == [['URL', 'string'], ['Description', 'text']]
    bookmark.template.should == '#{f :URL} // #{f :Description}'
    bookmark.name.should == 'Bookmark'
  end
end
