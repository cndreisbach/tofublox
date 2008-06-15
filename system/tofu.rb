#!/usr/bin/env ruby
$:.push(File.dirname(__FILE__))

['vendor/*/lib', 'vendor/sequel/*/lib'].each do |glob|
  Dir[File.join(File.dirname(__FILE__), glob)].each do |dir|
    $:.push(dir)
  end
end

require 'ramaze'
require 'sequel'
require 'active_files'

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
