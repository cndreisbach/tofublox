#!/usr/bin/env ruby

# set load paths
['', 'vendor/*/lib', 'vendor/sequel/*/lib'].each do |glob|
  Dir["#{File.dirname(__FILE__)}/#{glob}"].each do |dir|
    $:.push(dir)
  end
end

%w(rubygems ramaze sequel active_files).each do |requirement|
  require requirement
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

    require 'tofu/models'
    require 'tofu/controllers'
    require 'tofu/helpers'
    require 'tofu/routes'

    Tofu.load_molds
    Block.create_table unless Block.table_exists?
  end

  private

  def self.load_molds
    @molds = { }

    Mold.find(:all).each do |mold|
      @molds[mold.name] = mold
      mold.create_block
    end
  end
end

Tofu.setup

