require File.dirname(__FILE__) + '/../spec_helper'

describe 'MoldController' do

  behaves_like 'controller spec'
  
  it "should get a mold" do
    @controller.get('Post')
    @controller.assigns(:mold).should.not.be.nil
    @controller.assigns(:mold).should.be.instance_of Mold
  end
  
end
