json.array!(@preferences) do |preference|
  json.extract! preference, :id, :user_id, :email, :internal, :news_letters, :project_events, :purchase_events, :quote_events, :promotions
  json.url preference_url(preference, format: :json)
end
