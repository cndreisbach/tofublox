#!/usr/bin/env ruby

$TOFU_ENV ||= 'development'

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
    attr_reader :molds, :config, :db

    def dir(subdir = '')
      File.join(DIR, subdir)
    end

    def env
      $TOFU_ENV
    end

    def configure
      yield @config
    end

    def setup
      require dir('tofu_config')

      if env == 'test'
        @db = Sequel.sqlite
      else
        @db = Sequel.sqlite(@config.database) unless @config.database.nil?
      end

      acquire dir('system/tofu/*')

      load_molds
      Block.create_table unless Block.table_exists?
    end

    private

    def load_molds
      @molds = { }

      Mold.find(:all).each do |mold|
        @molds[mold.name] = mold
      end
    end
  end
 
end

Tofu.setup

