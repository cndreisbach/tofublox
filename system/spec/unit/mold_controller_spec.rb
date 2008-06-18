require File.dirname(__FILE__) + '/../spec_helper'

describe 'MoldController' do

  before do
    @controller = MoldController.new
  end

  it "should get a mold" do
    @controller.get('Post')
    @controller.assigns(:mold).should.not.be.nil
    @controller.assigns(:mold).should.be.instance_of Mold
  end
  
end
