#!/usr/bin/env ruby

require 'rubygems'
require 'camping'
require 'reststop'

Camping.goes :Tofu

module Tofu
  @block_definitions = {
    'Post' => {
      :title => :string,
      :body => :text
    }
  }

  def self.block_definitions
    @block_definitions
  end

  def self.blocks
    @block_definitions.keys.map { |name| name.to_s.capitalize }
  end

  def self.definitions_text(definitions)
    definitions.map { |definition| definition_text(*definition) }.join("\n")
  end

  def self.create
    Tofu::Models.create_schema

    Tofu.block_definitions.each do |name, definitions|
      class_def = <<EOF
      class #{name} < Block
        #{Tofu.definitions_text(definitions)}
      end
EOF
      p class_def
      Tofu::Models.module_eval(class_def)
    end
  end

  private
  
  def self.definition_text(name, type)
    return "
def #{name}
  content[#{name.to_s.inspect}]
end

def #{name}=(value)
  content[#{name.to_s.inspect}] = value
end
"
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
  class Molds < REST 'molds'
    def list
      @blocks = Tofu.blocks
      render :molds_list
    end

    def read(id)
      
    end
  end

  class Blocks < REST ''
    # GET /
    def list
      @blocks = Block.find(:all)
      render :list
    end

    # GET /:id
    def read(id)
      
    end

    # POST /:id
    def create
      
    end

    # PUT /:id
    def update(id)
      
    end

    # DELETE /:id
    def destroy(id)
      
    end
  end
end

module Tofu::Views
  module HTML
    include Tofu::Controllers
    
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
    
    def list
      @blocks.each do |block|
        div :class => 'block' do
          block.content
        end
      end
    end

    def molds_list
      h1 "Molds"
      ul do
        @blocks.each do |block|
          li do
            a(:href => R(Molds, block)) { block }
          end
        end
      end
    end
  end

  default_format :HTML
end
