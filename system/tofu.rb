#!/usr/bin/env ruby
$:.push(File.dirname(__FILE__))

require 'rubygems'
require 'camping'

Camping.goes :Tofu

Dir[File.join(File.dirname(__FILE__), 'vendor/*/lib')].each do |dir|
  $:.push(dir)
end

require 'active_files'
require 'tofu/models'
require 'tofu/controllers'
require 'tofu/helpers'

module Tofu
  DIR = File.join(File.dirname(__FILE__), '..') unless defined?(DIR)

  def self.dir
    DIR
  end

  def self.system_dir
    File.join(self.dir, 'system')
  end

  def self.template_dir
    File.join(self.system_dir, 'templates')
  end
end

ActiveFiles.base_dir = File.join(Tofu.dir, 'data')
