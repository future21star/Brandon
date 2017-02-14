require 'test_helper'

class AddressTest <  BaseModelTest
  def new
    return Address.new
  end

  test "house_number expected to be set" do
    instance = new
    has_key(instance, :house_number)
    instance.house_number = '301'
    not_has_key instance, :house_number
  end

  test "street_name expected to be set" do
    instance = new
    has_key(instance, :street_name)
    instance.street_name = 'Cookie Lane'
    not_has_key instance, :street_name
  end

  test "city expected to be set" do
    instance = new
    has_key(instance, :city)
    instance.city = 'Waterloo'
    not_has_key instance, :city
  end

  test "province expected to be set" do
    instance = new
    has_key(instance, :province)
    instance.province = Province.first
    not_has_key instance, :province
  end

  test "postal_code expected to be set" do
    instance = new
    has_key(instance, :postal_code)
    instance.postal_code = 'n1g5a3'
    not_has_key instance, :postal_code
  end

  test "postal code should be upper case" do
    instance = new
    expected = "N2V1P5"
    test_cases = ["n2v 1p5", "N2v1P5", " " + expected, expected.downcase]
    test_cases.each { |test_case|
      instance.postal_code = test_case
      instance.clean_input!
      assert_equal expected, instance.postal_code, "Test case: #{test_case}"
    }
  end

  test "validate postal_code bounds" do
    test_cases = [123456, 12345, 1, -3, 1234]
    expectations = [true, true, false, false, false]
    validate_bounds create_cooked_address, :postal_code, test_cases, expectations
  end

  test "validate house_numberbounds enforced" do
    test_cases = [0, 12345, 1234567890, 12345678901, 123456789032]
    expectations = [true, true, true, false, false]
    validate_bounds create_cooked_address, :house_number, test_cases, expectations
  end

  test "validate apartmentbounds enforced" do
    test_cases = [0, 12345, 1234567890, "12345678901asdf", 1234567890323456]
    expectations = [true, true, true, true, false]
    validate_bounds create_cooked_address, :apartment, test_cases, expectations
  end

  test "validate street_namebounds enforced" do
    test_cases = ["s", STRING_255, STRING_256]
    expectations = [true, true, false]
    validate_bounds create_cooked_address, :street_name, test_cases, expectations
  end

  test "validate citybounds enforced" do
    test_cases = ["s", STRING_255, STRING_256]
    expectations = [true, true, false]
    validate_bounds create_cooked_address, :city, test_cases, expectations
  end

  test "Geocoding happy path should save both objects" do
    lat = 43.499032
    lng = -80.55443
    instance = create_cooked_address
    instance.save

    location = instance.location
    assert location
    assert_equal lat, location.latitude
    assert_equal lng, location.longitude
    assert_equal instance, location.address
    assert location.id
  end

  test "Geocoding fails to find location should throw" do
    instance = Address.new postal_code: "nnnnnnaaaa"
    assert_raise do ArgumentError
      instance.geo_lookup
    end
  end

  test "full_address should format as expected" do
    address1 = create_cooked_address
    address2 = create_cooked_address(158, "Clairfields dr w", "Guelph", "n1G5A3",nil)
    address3 = create_cooked_address(234, "Clairfields", "Orange Ville", "n2j3p5",nil)

    save address1
    save address2
    save address3
    test_cases = [ address1, address2, address3]
    expected = ["301-B Mayview Cres, Waterloo, ON", "158 Clairfields dr w, Guelph, ON", "234 Clairfields, Orange Ville, ON"]
    test_cases.each_index { |i|
       address = test_cases[i]
      assert_not_nil address
      assert_not_nil address.id

      assert_equal expected[i], address.full_address
    }
  end
end
