require 'rake'
require 'rcov/rcovtask'

task :default => :spec

TOFU_DIR = File.dirname(__FILE__) + '/system'
$:.push TOFU_DIR

desc 'Run all specs'
task 'spec' do
  require "#{TOFU_DIR}/vendor/ramaze/spec/helper"
  files = Dir["system/spec/**/*_spec.rb"]
  Bacon.summary_on_exit
  files.each { |file| load file }
end

Rcov::RcovTask.new do |t|
  t.rcov_opts = ['-x spec.rb,spec_helper.rb', '-T', '--only-uncovered']
  t.pattern = "system/spec/**/*_spec.rb"
  t.verbose = true
end

desc "Run reek"
task 'reek' do
  system "reek #{system_files.join(' ')}"
end

desc "Run roodi"
task 'roodi' do
  system "roodi #{system_files.join(' ')}"
end

desc "Run flog"
task 'flog' do
  system "flog #{system_files.join(' ')}"
end

desc "Dump database to yaml"
task 'dump' do
  require 'tofu'
  Tofu.dump_to_file(ENV['TOFU_YAML'])
end

desc "Load database from yaml"
task 'load' do
  require 'tofu'
  Tofu.load_from_file(ENV['TOFU_YAML'])
end

def system_files
  Dir['system/tofu.rb'] + Dir['system/tofu/**/*.rb']
end

