json.array!(@addresses) do |address|
  json.extract! address, :id, :house_number, :postal_code, :apartment, :city, :street_name
  json.url address_url(address, format: :json)
end
