class Owner
  include DataMapper::Resource

  property :id, Serial
  property :full_name, String, :required => true
  belongs_to :company
end
