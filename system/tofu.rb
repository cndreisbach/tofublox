#!/usr/bin/env ruby

require 'rubygems'
require 'camping'

unless defined? ERB
  begin
    require 'erubis'
    ERB = Erubis::Eruby
  rescue
    require 'erb'
  end
end

Camping.goes :Tofu

module Tofu
  include Tofu::Controllers
  
  DIR = File.join(File.dirname(__FILE__), '..') unless defined?(DIR)
  
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

  def render(m, layout=true)
    content = ERB.new(IO.read("#{DIR}/templates/#{m}.html.erb")).result(binding)
    content = ERB.new(IO.read("#{DIR}/templates/layout.html.erb")).result(binding) if layout
    return content
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
      @name = id
      @mold = Tofu.molds[id]
      render :mold
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
end

module Tofu::Helpers
  def form_field(datatype, options)
    case datatype
    when 'string':
        input options.merge(:type => 'text')
    when 'text':
        textarea options[:value], options.delete(:name)
    end
  end
end
