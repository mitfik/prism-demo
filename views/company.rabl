object @company
attributes :id, :name, :address, :city, :country, :email, :phone_number, :owners
if @company
  node(:status) {
    if @company.errors.empty?
      "OK"
    else
      node(:errors) { @company.errors }
      "Failed"
    end
  }
end
