require 'rake'

task :default => :spec

TOFU_DIR = File.dirname(__FILE__) + '/system'
$:.push TOFU_DIR

require 'vendor/ramaze/lib/ramaze/snippets/divide'
require 'vendor/ramaze/lib/ramaze/snippets/string/color'

desc 'Run all specs'
task 'spec' do
  non_verbose, non_fatal = ENV['non_verbose'], ENV['non_fatal']
  require 'scanf'

  specs = Dir[TOFU_DIR/'spec/**/*_spec.rb']

  config = RbConfig::CONFIG
  bin = config['bindir']/config['ruby_install_name']

  result_format = '%d tests, %d assertions, %d failures, %d errors'

  list = specs.sort
  names = list.map{|l| l.sub(TOFU_DIR + '/spec/', '') }
  width = names.sort_by{|s| s.size}.last.size
  total = names.size

  list.zip(names).each_with_index do |(spec, name), idx|
    print '%3d/%d: ' % [idx + 1, total]
    print name.ljust(width + 2)

    stdout = `#{bin} -I#{TOFU_DIR} #{spec} 2>&1`

    status = $?.exitstatus
    tests, assertions, failures, errors =
      stdout[/.*\Z/].to_s.scanf(result_format)

    if stdout =~ /Usually you should not worry about this failure, just install the/
      lib = stdout[/^no such file to load -- (.*?)$/, 1] ||
        stdout[/RubyGem version error: (.*)$/, 1]
      puts "requires #{lib}".yellow
    elsif status == 0
      puts "all %3d passed".green % tests
    else
      out = result_format % [tests, assertions, failures, errors].map{|e| e.to_s.to_i}
      puts out.red
      puts stdout unless non_verbose
      exit status unless non_fatal
    end
  end
end

