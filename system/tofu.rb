#!/usr/bin/env ruby

# set load paths
['', 'vendor/*/lib', 'vendor/sequel/*/lib'].each do |glob|
  Dir["#{File.dirname(__FILE__)}/#{glob}"].each do |dir|
    $:.push(dir)
  end
end

%w(ramaze sequel active_files).each do |requirement|
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
      require dir('config/tofu_config')
      load_db
      Ramaze.acquire dir('system/tofu/**/*')
      load_molds
      Block.create_table unless Block.table_exists?
      Ramaze::Global.view_root = dir('templates')
    end

    def dump
      File.open(dir('tofu.yaml'), 'w') do |file|
        file.write Block.all_values.to_yaml
      end
    end

    def load(yaml_file = dir('tofu.yaml'))
      if File.exist?(yaml_file)
        blocks = YAML::load(File.read(yaml_file))
        unless blocks.blank?
          Block.delete_all
          blocks.each do |vals|
            block = Block.new(vals)
            block.save
          end
        end
        p Block.all.inspect
      else
        raise "Could not load #{yaml_file}."
      end
    end

    private

    def load_molds
      @molds = { }

      Mold.find(:all).each do |mold|
        @molds[mold.name] = mold
      end
    end
    
    def load_db
      unless @db
        @db = Sequel.sqlite((env == 'test') ? ':memory:' : @config.database)
      end
    end
  end
 
  module Errors
    class Unauthorized < Exception; end
    class BadRequest < Exception; end
    class NotFound < Exception; end
    class MethodNotAllowed < Exception; end
  end  
end

Tofu.setup
