require 'rubygems'
require 'mosquito'
require 'spect'
require 'shoulda'
require File.dirname(__FILE__) + '/../tofu'

Tofu.create

class TestTofu < Camping::UnitTest
  include Tofu::Models

  context "Tofu module" do
    should "load Post mold" do
      expect(defined? Post).to.be "constant"
    end
    
    should "be able to make new molds" do
      review_mold = {
        'thing' => 'string',
        'stars' => 'numeric',
        'thoughts' => 'text'
      }
      Tofu.make_new_mold('Review', review_mold)

      expect(defined?(Review)).to.be "constant"

      expect(Review.new).to.respond_to :thing
      expect(Review.new).to.respond_to :stars
      expect(Review.new).to.respond_to :thoughts
    end
  end
end

class TestBlock < Camping::UnitTest
  include Tofu::Models
  
  context "a new block" do
    should "be valid" do
      block = Block.new
      expect(block).to.be.valid
    end
  end
end
