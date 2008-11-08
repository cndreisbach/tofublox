Tofu.configure do |config|
  config.title = "TofuBlox"
  config.database = "#{File.expand_path(File.dirname(__FILE__))}/system/tofu.db"
  config.admin_password = 'lombardo'
end
