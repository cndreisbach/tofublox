require 'rake'

task :default => :spec

TOFU_DIR = File.dirname(__FILE__) + '/system'
$:.push TOFU_DIR

desc 'Run all specs'
task 'spec' do
  exec "find #{TOFU_DIR}/spec -name '*_spec.rb' | xargs bacon"
end

