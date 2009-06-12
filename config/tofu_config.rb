Tofu.configure do |config|
  
   # Your site title
  config.title = "Your TofuBlox Site"
  
  # The password to get into your admin backend
  config.admin_password = 'lombardo' 
  
  # How many blocks to show on the index page
  config.blocks_per_page = 7
  
  # Where your super-secret SQLite database is stored
  config.database = File.expand_path(Tofu.dir("system/tofu.db"))
end
