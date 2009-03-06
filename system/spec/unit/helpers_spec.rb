require File.dirname(__FILE__) + '/../spec_helper'

describe 'Form Helper' do
  class << self
    include Ramaze::Helper::Form
  end

  it "should return a textarea for text fields" do
    form_field('text', {}).should == '<textarea name=""></textarea>'
  end

  it "should return a textarea for markdown fields" do
    form_field('text', {}).should == '<textarea name=""></textarea>'
  end

  it "should return an input for string fields" do
    form_field('string', {}).should == '<input type="text" name="" value="" />'
  end
end
