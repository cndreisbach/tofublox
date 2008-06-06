#!/usr/bin/env ruby
$:.push(File.dirname(__FILE__))

require 'rubygems'
require 'camping'

Camping.goes :Tofu

require 'tofu/models'
require 'tofu/controllers'
require 'tofu/helpers'

module Tofu
  DIR = File.dirname(__FILE__) + '/..' unless defined?(DIR)

  def self.dir
    DIR
  end
  
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
    Models.create_schema
    load_molds
  end

  def self.make_new_mold(name, hash)
    @molds[name] = hash

    Models.module_eval("
      class #{name} < Block
        #{Tofu.mold_text(@molds[name])}
      end"
    )
  end

  private

  def self.load_molds
    Dir["#{DIR}/molds/*.yaml"].each do |file|
      make_new_mold(File.basename(file, '.yaml').capitalize,
                    YAML::load(File.read(file)))
    end
  end
  
  def self.field_text(name, type)
    "
      def #{name}
        content[#{name.to_s.inspect}]
      end

      def #{name}=(value)
        content[#{name.to_s.inspect}] = value
      end
    "
  end
end

if __FILE__ == $0
  Tofu::Models::Base.establish_connection(:adapter => 'sqlite3',
                                          :database => 'tofu.db')
  Tofu::Models::Base.logger = Logger.new('tofu.log')
  Tofu.create
  
  require 'mongrel'
  require 'rack/adapter/camping'
  require 'rack/handler/mongrel'
  app = Rack::Adapter::Camping.new(Tofu) do
    use Rack::CommonLogger
    use Rack::ShowExceptions
    use Rack::ShowStatus
    use Rack::Lint
    Tofu.run
  end
  
  Rack::Handler::Mongrel.run app, :Port => 3301
end
