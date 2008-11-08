require 'rake'

task :default => :spec

TOFU_DIR = File.dirname(__FILE__) + '/system'
$:.push TOFU_DIR
require "#{TOFU_DIR}/vendor/ramaze/spec/helper"

desc 'Run all specs'
task 'spec' do
  files = Dir["system/spec/**/*_spec.rb"]
  Bacon.summary_on_exit
  files.each { |file| load file }
end

