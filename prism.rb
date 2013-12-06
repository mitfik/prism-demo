require 'sinatra/base'
require 'sinatra/config_file'
require 'data_mapper'
require 'json'
require 'rabl'

require './models/company'
require './models/owner'

class Prism < Sinatra::Base
  register Sinatra::ConfigFile

  config_file File.join(ENV['CONFIG_FILE'] || "config/settings.yml")
  set :upload_path, File.join(settings.root, "pdfs") unless settings.respond_to? :upload_path

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

  before do
    content_type 'application/json'
  end

  get '/' do
    "Welcome in PRISM demo"
  end

  # List all companies in database
  get '/companies', :provides => [:json] do
    @companies = Company.all
    rabl :companies, :fromat => :json
  end

  # Create new company
  post '/company', :provides => [:json] do
    begin
      params = JSON.parse(request.body.read.to_s)
      owners = params.delete("owners")
      @company = Company.new(params)
      @company.save
      owners.each do |owner|
        @company.owners.create(owner)
      end
      rabl :company, :format => :json
    rescue => msg
      render_400
    end
  end

  # Update existing company base on given id
  put '/company/:id', :provides => [:json] do
    begin
      attributes = JSON.parse(request.body.read.to_s)
      owners = attributes.delete("owners") || []
      @company = Company.get(params["id"])
      if @company
        @company.update(attributes)
        owners.each do |owner_attr|
          owner = Owner.get(owner_attr["id"])
          if owner
            owner.update(owner_attr)
          else
            @company.owners.create(owner_attr)
          end
        end
        rabl :company, :format => :json
      else
        render_404
      end
    rescue => msg
      render_400
    end
  end

  # Upload pdf file for give company
  put '/company/:id/upload', :provides => [:json] do
    company = Company.get(params["id"])

    if company
      @error_msg = company.upload_pdf(params["file"], settings.upload_path)
      if @error_msg
        status 500
        rabl :pdf, :format => :json
      else
        status 200
      end
    else
        render_404
    end
  end

  # Fetch company detail base on given id
  get '/company/:id', :provides => [:json] do
    @company = Company.get(params["id"])
    if @company
      rabl :company, :format => :json
    else
      render_404
    end
  end

  not_found do
    render_404
  end

  private
    def render_404
      status 404
    end

    def render_400
      status 400
    end

end
