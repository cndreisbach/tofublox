#!/usr/bin/env ruby
$:.push(File.dirname(__FILE__))

require 'rubygems'
require 'camping'

Camping.goes :Tofu

require 'vendor/active_files/lib/active_files'
require 'tofu/models'
require 'tofu/controllers'
require 'tofu/helpers'

module Tofu

  DIR = File.dirname(__FILE__) + '/..' unless defined?(DIR)

  def self.dir
    DIR
  end

end

ActiveFiles.base_dir = File.join(Tofu.dir, 'data')
