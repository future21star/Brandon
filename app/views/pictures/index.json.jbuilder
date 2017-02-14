json.array!(@pictures) do |picture|
  json.extract! picture, :id, :a, :generated_name, :extension, :user_id
  json.url picture_url(picture, format: :json)
end
