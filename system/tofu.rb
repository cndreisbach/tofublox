#!/usr/bin/env ruby

# set load paths
['', 'vendor/*/lib', 'vendor/sequel/*/lib'].each do |glob|
  Dir["#{File.dirname(__FILE__)}/#{glob}"].each do |dir|
    $:.push(dir)
  end
end

%w(ramaze rubygems sequel active_files).each do |requirement|
  require requirement
end

module Tofu
  DIR = File.join(File.dirname(__FILE__), '..') unless defined?(DIR)
  @config = Struct.new(:title,
                       :database, 
                       :admin_password).new
  @molds = { }

  class << self
    attr_reader :molds, :config, :db

    def dir(subdir = '')
      File.join(DIR, subdir)
    end

    def env
      ENV['RACK_ENV'] || 'development'
    end

    def configure
      yield @config
    end

    def setup
      Ramaze::Global.view_root = dir('templates')

      require dir('config/tofu_config')

      unless @db
        @db = Sequel.sqlite((env == 'test') ? ':memory:' : @config.database)
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


class String
  def slugify
    self.strip.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').gsub(/[\s\.:;=+]+/, '-')
  end
end

Tofu.setup
