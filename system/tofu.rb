#!/usr/bin/env ruby

$:.push(File.dirname(__FILE__))

['vendor/*/lib', 'vendor/sequel/*/lib'].each do |glob|
  Dir["#{File.dirname(__FILE__)}/#{glob}"].each do |dir|
    $:.push(dir)
  end
end

require 'ramaze'
require 'sequel'
require 'active_files'

module Tofu
  class Config < Struct.new(:database, :admin_password); end
  
  DIR = File.join(File.dirname(__FILE__), '..') unless defined?(DIR)
  @config = Config.new
  @molds = { }
  @db = nil
  
  def self.dir(subdir = '')
    File.join(DIR, subdir)
  end

  def self.config
    @config
  end

  def self.molds
    @molds
  end

  def self.configure
    yield @config
  end

  def self.setup
    require Tofu.dir + '/tofu_config'
    Sequel::Model.db = Sequel.connect(config.database)
    ActiveFiles.base_dir = File.join(Tofu.dir, 'data')

    require 'models/mold'
    require 'models/block'
    require 'controllers/mold_controller'
    
    Tofu.load_molds
    Block.create_table unless Block.table_exists?
  end

  private

  def self.load_molds
    @molds = { }
    mold_array = Mold.find(:all)
    mold_array.each do |mold|
      create_block(mold.name, mold.fields)
      @molds[mold.name] = mold
    end
  end

  def self.create_block_fields(fields)
    fields.map { |field, definition| create_block_field(field) }.join("\n")
  end

  def self.create_block_field(field)
    "def #{field}; self.content['#{field}']; end\n" +
      "def #{field}=(data); self.content['#{field}'] = data; end"
  end

  def self.create_block(name, fields)
    self.module_eval <<EOF
class ::#{name} < Block
  #{create_block_fields(fields)}
end
EOF
  end
end

Tofu.setup

# Ramaze::Route['REST dispatch'] = lambda do |path, request|
#   path << '/' unless path[-1] == '/'

#   method = if request.request_method == 'POST' and request.params.has_key?('method')
#              request.params['method'].upcase
#            else
#              request.request_method
#            end
  
#   case method
#   when 'GET' then path << 'get/'
#   when 'POST' then path << 'post/'
#   when 'PUT' then path << 'put/'
#   when 'DELETE' then path << 'delete/'
#   else path
#   end
# end
