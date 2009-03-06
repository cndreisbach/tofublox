require File.dirname(__FILE__) + '/../spec_helper'

describe 'Tofu Controller' do

  behaves_like 'controller spec'

  it "should not implement methods by default" do
    %w(get post put delete).each do |action|
      lambda { @controller.send(action) }.should.raise Tofu::Errors::MethodNotAllowed
    end
  end

end
