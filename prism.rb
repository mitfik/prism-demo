require 'sinatra/base'
require 'sinatra/config_file'
require 'data_mapper'
require 'rabl'

require './models/company'

class Prism < Sinatra::Base
  register Sinatra::ConfigFile

  config_file File.join(ENV['CONFIG_FILE'] || "config/database.yml")

  def self.initialize_database
    begin
      DataMapper.setup(:default, settings.database_uri)
      DataMapper.finalize.auto_upgrade!
    rescue => msg
      raise "Problem with establish connection to database."
    end
  end

  configure do
    initialize_database
    Rabl.register!
  end

  get '/' do
    "Welcome in PRISM demo"
  end

  get '/companies' do
    @companies = DataMapper.repository(:default) {Company.all}
    rabl :companies, :fromat => :json
  end
end
