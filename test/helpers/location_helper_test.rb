require 'test_helper'

class LocationHelperTest < ActionController::TestCase
  test "postal code should be upper case" do
    expected = "N2V1P5"
    test_cases = ["n2v 1p5", "N2v1P5", " " + expected, expected.downcase]
    test_cases.each { |test_case|
      postal_code = LocationHelper.clean_postal_code test_case
      assert_equal expected, postal_code, "Test case: #{test_case}"
    }
  end

  test "Geocoding with bad lookup should throw error" do
    ontario = Province.find_by_name "Ontario"
    instance = Address.new house_number: "301", street_name: "Mayview crescent ", city: "Waterloo",
                           province: ontario, postal_code: "nnnnnnaaaa"
    assert_raise(ArgumentError) do
      LocationHelper.geocode_by_address(instance)
      assert_fail("This should never be hit")
    end
  end

end
