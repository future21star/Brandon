
class Preference < BaseModel
  USER_PREFERENCES = [
      PREFERENCE_NEWS_LETTERS = "News Letters",
      PREFERENCE_PROMOTIONS = "Promotions",
      PREFERENCE_PROJECT_EVENTS = "Project Events",
  ]

  BUSINESS_PREFERENCES = [
      PREFERENCE_PURCHASE_EVENTS = "Purchase Events",
      PREFERENCE_QUOTE_EVENTS = "Quote Events"
  ]

  validates_presence_of :name

  def readonly?
    true
  end
end
