require 'rake'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << "system/test"
  t.pattern = 'system/test/*_test.rb'
  t.verbose = true
end

