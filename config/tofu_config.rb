Tofu.configure do |config|
  config.title = "TofuBlox"
  config.database = File.expand_path(Tofu.dir("system/tofu.db"))
  config.admin_password = 'lombardo'
  config.blocks_per_page = 7
end
