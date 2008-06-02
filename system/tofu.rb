#!/usr/bin/env ruby
$:.push(File.dirname(__FILE__))

require 'rubygems'
require 'camping'

Camping.goes :Tofu

require 'tofu/models'
require 'tofu/controllers'
require 'tofu/helpers'

module Tofu
  include Controllers
  
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
    Models.create_schema
    load_molds
  end

  def render(m, layout=true)
    content = ERB.new(IO.read("#{DIR}/templates/#{m}.html.erb")).result(binding)
    content = ERB.new(IO.read("#{DIR}/templates/layout.html.erb")).result(binding) if layout
    return content
  end

  def self.make_new_mold(name, hash)
    @molds[name] = hash

    Models.module_eval(%Q{
      class #{name} < Block
        #{Tofu.mold_text(@molds[name])}
      end}
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
