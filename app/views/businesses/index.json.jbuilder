json.array!(@businesses) do |business|
  json.extract! business, :id, :user_id, :company_name, :phone_number, :biography, :website
  json.url business_url(business, format: :json)
end
