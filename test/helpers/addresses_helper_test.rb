require 'test_helper'

class AddressesHelperTest < ActionController::TestCase
  test "Country list should only contain supported countries" do
    countries = AddressesHelper.get_country_list
    assert_equal SUPPORTED_COUNTRIES.count, countries.count
    country_names = countries.each {|country| country.name}
    assert_equal country_names, countries
  end

  test "Province list for country should return expected" do
    canada = countries(:one)
    assert canada
    provinces = canada.provinces
    assert provinces
    assert_equal 1, provinces.count
  end
end
