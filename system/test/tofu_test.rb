require 'rubygems'
require 'test/unit'
require 'mysticize'
require File.dirname(__FILE__) + '/../tofu'

class TofuTest < Test::Unit::TestCase
  context "Tofu module" do
    should "load Post mold" do
      expect(defined? Post).to.be "constant"
    end
    
    should "be able to make new block types" do
      review_fields = {
        'thing' => 'string',
        'stars' => 'numeric',
        'thoughts' => 'text'
      }

      review_mold = Mold.new('Review', review_fields)
      review_mold.create_block

      expect(defined?(Review)).to.be "constant"

      expect(Review.new).to.respond_to :thing
      expect(Review.new).to.respond_to :stars
      expect(Review.new).to.respond_to :thoughts
    end
  end
end

class BlockTest < Test::Unit::TestCase
  context "a new block" do
    should "be valid" do
      block = Block.new
      expect(block).to.be.valid
    end
  end
end
