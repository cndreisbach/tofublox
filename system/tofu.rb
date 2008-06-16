#!/usr/bin/env ruby

$:.push(File.dirname(__FILE__))

['vendor/*/lib', 'vendor/sequel/*/lib'].each do |glob|
  Dir["#{File.dirname(__FILE__)}/#{glob}"].each do |dir|
    $:.push(dir)
  end
end

require 'rubygems'
require 'ramaze'
require 'sequel'
require 'active_files'

unless defined? ERB
  begin
    require 'erubis'
    ERB = Erubis::Eruby
  rescue MissingSourceFile
    require 'erb'
  end
end

module Tofu
  DIR = File.join(File.dirname(__FILE__), '..') unless defined?(DIR)
  @config = Struct.new(:database, :admin_password).new
  @molds = { }
  @db = nil
  
  def self.dir(subdir = '')
    File.join(DIR, subdir)
  end

  def self.molds
    @molds
  end

  def self.configure
    yield @config
  end

  def self.setup
    require Tofu.dir + '/tofu_config'
    Sequel::Model.db = Sequel.connect(@config.database) unless @config.database.nil?

    # require all controllers and models
    require 'tofu/models'
    require 'tofu/controllers'
    require 'tofu/helpers'

    Tofu.load_molds
    Block.create_table unless Block.table_exists?
  end

  private

  def self.load_molds
    @molds = { }

    Mold.find(:all).each do |mold|
      create_block(mold.name, mold)
    end
  end

  def self.create_block_fields(fields)
    fields.map { |field, definition| create_block_field(field) }.join("\n")
  end

  def self.create_block_field(field)
    "def #{field}; self.content['#{field}']; end\n" +
      "def #{field}=(data); self.content['#{field}'] = data; end"
  end

  def self.create_block(name, mold)
    @molds[name] = mold
    self.module_eval("class ::#{name} < Block
                        #{create_block_fields(mold.fields)}
                      end")
  end
end

Tofu.setup

def get_request_method(request)
  method = if request.request_method == 'POST' and request.params.has_key?('method')
             request.params['method']
           else
             request.request_method
           end
  method.downcase
end

Ramaze::Route['Tofu routing'] = lambda do |path, request|
  method = get_request_method(request)
  
  case path
  when '/error' then "/errors/index"
  when '/molds' then "/molds/#{method}"
  when %r{/mold/(\w+)} then "/mold/#{method}/#{$1}"
  when '/blocks' then "/blocks/#{method}"
  when %r{/block/([\w\-]+)} then "/block/#{method}/#{$1}"
  when '/' then "/blocks/#{method}"
  when %r{/([\w\-]+)} then "/block/#{method}/#{$1}"
  end
end
