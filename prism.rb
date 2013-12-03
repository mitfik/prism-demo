require 'sinatra/base'
require 'sinatra/config_file'

class Prism < Sinatra::Base
  register Sinatra::ConfigFile

  config_file File.join(ENV['CONFIG_FILE'] || "config/database.yml")

  get '/' do
    "Welcome in PRISM demo"
  end
end
