
class SeedableProvince < Province
  def readonly?
    false
  end
end



canada = Country.find_by_alpha2 'CA'
us = Country.find_by_alpha2 'US'

# Province is readonly, so override that attribute temporarily
SeedableProvince.create([
          {:name => "Alabama", :code => "AL", :country => us},
          {:name => "Alaska", :code => "AK", :country => us},
          {:name => "Arizona", :code => "AZ", :country => us},
          {:name => "Arkansas", :code => "AR", :country => us},
          {:name => "California", :code => "CA", :country => us},
          {:name => "Colorado", :code => "CO", :country => us},
          {:name => "Connecticut", :code => "CT", :country => us},
          {:name => "Delaware", :code => "DE", :country => us},
          {:name => "Florida", :code => "FL", :country => us},
          {:name => "Georgia", :code => "GA", :country => us},
          {:name => "Hawaii", :code => "HI", :country => us},
          {:name => "Idaho", :code => "ID", :country => us},
          {:name => "Illinois", :code => "IL", :country => us},
          {:name => "Indiana", :code => "IN", :country => us},
          {:name => "Iowa", :code => "IA", :country => us},
          {:name => "Kansas", :code => "KS", :country => us},
          {:name => "Kentucky", :code => "KY", :country => us},
          {:name => "Louisiana", :code => "LA", :country => us},
          {:name => "Maine", :code => "ME", :country => us},
          {:name => "Maryland", :code => "MD", :country => us},
          {:name => "Massachusetts", :code => "MA", :country => us},
          {:name => "Michigan", :code => "MI", :country => us},
          {:name => "Minnesota", :code => "MN", :country => us},
          {:name => "Mississippi", :code => "MS", :country => us},
          {:name => "Missouri", :code => "MO", :country => us},
          {:name => "Montana", :code => "MT", :country => us},
          {:name => "Nebraska", :code => "NE", :country => us},
          {:name => "Nevada", :code => "NV", :country => us},
          {:name => "New Hampshire", :code => "NH", :country => us},
          {:name => "New Jersey", :code => "NJ", :country => us},
          {:name => "New Mexico", :code => "NM", :country => us},
          {:name => "New York", :code => "NY", :country => us},
          {:name => "North Carolina", :code => "NC", :country => us},
          {:name => "North Dakota", :code => "ND", :country => us},
          {:name => "Ohio", :code => "OH", :country => us},
          {:name => "Oklahoma", :code => "OK", :country => us},
          {:name => "Oregon", :code => "OR", :country => us},
          {:name => "Pennsylvania", :code => "PA", :country => us},
          {:name => "Rhode Island", :code => "RI", :country => us},
          {:name => "South Carolina", :code => "SC", :country => us},
          {:name => "South Dakota", :code => "SD", :country => us},
          {:name => "Tennessee", :code => "TN", :country => us},
          {:name => "Texas", :code => "TX", :country => us},
          {:name => "Utah", :code => "UT", :country => us},
          {:name => "Vermont", :code => "VT", :country => us},
          {:name => "Virginia", :code => "VA", :country => us},
          {:name => "Washington", :code => "WA", :country => us},
          {:name => "West Virginia", :code => "WV", :country => us},
          {:name => "Wisconsin", :code => "WI", :country => us},
          {:name => "Wyoming", :code => "WY", :country => us},
          {:name => "Puerto Rico", :code => "PR", :country => us},
          {:name => "U.S. Virgin Islands", :code => "VI", :country => us},
          {:name => "American Samoa", :code => "AS", :country => us},
          {:name => "Guam", :code => "GU", :country => us},
          {:name => "Northern Mariana Islands", :code => "MP", :country => us},
          {:name => "Alberta", :code => "AB", :country => canada},
          {:name => "British Columbia", :code => "BC", :country => canada},
          {:name => "Manitoba", :code => "MB", :country => canada},
          {:name => "New Brunswick", :code => "NB", :country => canada},
          {:name => "Newfoundland and Labrador", :code => "NL", :country => canada},
          {:name => "Nova Scotia", :code => "NS", :country => canada},
          {:name => "Ontario", :code => "ON", :country => canada},
          {:name => "Prince Edward Island", :code => "PE", :country => canada},
          {:name => "Quebec", :code => "QC", :country => canada},
          {:name => "Saskatchewan", :code => "SK", :country => canada},
          {:name => "Northwest Territories", :code => "NT", :country => canada},
          {:name => "Nunavut", :code => "NU", :country => canada},
          {:name => "Yukon Territory", :code => "YT", :country => canada}
         ])
