json.array!(@promo_codes) do |promo_code|
  json.extract! promo_code, :id, :start_date, :end_date, :code, :discount, :description
  json.url promo_code_url(promo_code, format: :json)
end
