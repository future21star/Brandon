json.array!(@notification_templates) do |notification_template|
  json.extract! notification_template, :id, :summary_key, :body_key, :classification
  json.url notification_template_url(notification_template, format: :json)
end
