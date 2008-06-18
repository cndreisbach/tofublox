require File.dirname(__FILE__) + '/../spec_helper'

describe 'Molds Controller' do

  before do
    @controller = MoldsController.new
  end

  it "should get an array of molds" do
    @controller.get
    @controller.assigns(:molds).should.not.be.nil

    @controller.assigns(:molds).each do |mold|
      mold.should.be.instance_of Mold
    end
  end
  
end
