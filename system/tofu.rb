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

  class << self
    attr_reader :molds, :config

    def dir(subdir = '')
      File.join(DIR, subdir)
    end

    def configure
      yield @config
    end

    def setup
      require dir('tofu_config')
      Sequel::Model.db = Sequel.connect(@config.database) unless @config.database.nil?

      acquire dir('system/tofu/*')

      load_molds
      Block.create_table unless Block.table_exists?
    end

    private

    def load_molds
      @molds = { }

      Mold.find(:all).each do |mold|
        @molds[mold.name] = mold
        mold.create_block
      end
    end
  end
 
end

Tofu.setup

