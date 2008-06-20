require File.dirname(__FILE__) + '/../spec_helper'

describe 'Molds Controller' do

  behaves_like 'controller spec'

  it "should get an array of molds" do
    @controller.get
    @controller.assigns(:molds).should.not.be.nil

    @controller.assigns(:molds).each do |mold|
      mold.should.be.instance_of Mold
    end
  end
  
end
