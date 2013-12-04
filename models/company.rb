class Company
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :address, String, :required => true
  property :city, String, :required => true
  property :country, String, :required => true
  property :email, String, :format => :email_address
  property :phone_number, String
  property :owners, Json
end
