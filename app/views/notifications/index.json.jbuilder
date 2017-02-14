json.array!(@notifications) do |notification|
  json.extract! notification, :id, :user_id, :notification_template_id, :seen
  json.url notification_url(notification, format: :json)
end
