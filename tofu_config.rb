Tofu.configure do |config|
  config.database = "sqlite:#{File.expand_path(File.dirname(__FILE__))}/tofu.db"
  config.admin_password = 'lombardo'
end
