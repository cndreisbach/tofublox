Tofu.configure do |config|
  config.title = "TofuBlox"
  config.database = File.expand_path(Tofu.dir("system/tofu.db"))
  config.admin_password = 'lombardo'
end
