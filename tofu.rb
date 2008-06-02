#!/usr/bin/env ruby

require 'rubygems'
require 'camping'

Camping.goes :Tofu

module Tofu
  DIR = File.dirname(__FILE__) unless defined?(DIR)
  
  @molds = { }

  def self.molds
    @molds
  end

  def self.mold_names
    @molds.keys
  end

  def self.mold_text(mold)
    mold.map { |field| field_text(*field) }.join("\n")
  end

  def self.create
    Tofu::Models.create_schema

    Tofu.load_molds

    Tofu.molds.each do |name, mold|
      Tofu::Models.module_eval(%Q{
      class #{name} < Block
        #{Tofu.mold_text(mold)}
      end})
    end
  end

  private

  def self.load_molds
    Dir["#{DIR}/molds/*.yaml"].each do |yaml_file|
      @molds[File.basename(yaml_file, '.yaml').capitalize] = \
        YAML::load(File.read(yaml_file))
    end
  end
  
  def self.field_text(name, type)
    %Q(
      def #{name}
        content[#{name.to_s.inspect}]
      end

      def #{name}=(value)
        content[#{name.to_s.inspect}] = value
      end
    )
  end
end

module Tofu::Models
  class Block < Base
    attr_accessor :content
    serialize :content

    def content
      write_attribute(:content, Hash.new) if read_attribute(:content).nil?
      read_attribute(:content)
    end
  end
  
  class InitialDB < V 1.0
    def self.up
      create_table :tofu_blocks do |t|
        t.text :content, :null => false
        t.string :type, :null => false
        t.timestamps
      end
    end
  end
end

module Tofu::Controllers
  class MoldList < R '/molds'
    def get
      @molds = Tofu.mold_names
      render :mold_list
    end
  end

  class Mold < R '/molds/(\w+)'
    def get(id)
    end
  end

  class BlockList < R '/'
    def get
      @blocks = Block.find(:all)
      render :block_list
    end

    # create a block
    def post
      
    end
  end

  class Block
  end
end

module Tofu::Views  
  def layout
    html do
      head do
        title 'tofu'
      end
      body do
        self << yield
      end
    end
  end
    
  def block_list
    @blocks.each do |block|
      div :class => 'block' do
        block.content
      end
    end
  end

  def mold_list
    h1 "Molds"
    ul do
      @molds.each do |mold|
        li do
          a(mold, :href => R(Mold, mold))
        end
      end
    end
  end
end
