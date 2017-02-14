require 'test_helper'

class CountryTest < ActiveSupport::TestCase
   test "country should be read only, no update" do
     country = Country.first
     country.alpha2 = "no"
     assert_raise do ReadOnlyRecord
      country.save!
     end
   end

   test "country should be read only, no save" do
     country = Country.new(:alpha2 => 'no', :alpha3 => 'bad')
     assert_raise do ReadOnlyRecord
      country.save!
     end
   end
end
