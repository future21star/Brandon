class SeedablePreference < Preference
  def readonly?
    false
  end
end

SeedablePreference.create([
               {name: Preference::PREFERENCE_NEWS_LETTERS},
               {name: Preference::PREFERENCE_PROMOTIONS},
               {name: Preference::PREFERENCE_PURCHASE_EVENTS},
               {name: Preference::PREFERENCE_PROJECT_EVENTS},
               {name: Preference::PREFERENCE_QUOTE_EVENTS},
           ])
