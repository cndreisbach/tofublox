require File.dirname(__FILE__) + '/../spec_helper'

describe 'a Mold' do

  before do
    @fields = { 'URL' => 'string', 'Description' => 'text' }
    @summary = @body = '#{f :URL} // #{f :Description}'
    
    @mold = Mold.new('Bookmark', @fields, @summary, @body)
  end

  it "should have a name" do
    @mold.name.should == 'Bookmark'
  end

  it "should have a string representation" do
    @mold.to_s.should == 'Bookmark'
  end

  %w(fields summary body).each do |varname|
    it "should have #{varname}" do
      @mold.should.respond_to(varname)
      @mold.send(varname).should == instance_variable_get("@#{varname}")
    end
  end

end


describe 'Mold class' do
  it "should define its file store in the user dir" do
    Mold.file_store.should == Tofu.dir('molds')
  end

  it "should be able to be created from a text format" do
    mold_text = %q[---
Fields:
- URL: string
- Description: text
---
#{f :URL}
---
#{f :URL} // #{f :Description}]
    bookmark = Mold.from_activefile(mold_text, 'Bookmark')

    bookmark.fields.should == [['URL', 'string'], ['Description', 'text']]
    bookmark.summary.should == '#{f :URL}'
    bookmark.body.should == '#{f :URL} // #{f :Description}'
    bookmark.name.should == 'Bookmark'
  end
end
