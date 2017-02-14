require 'test_helper'

class LocationTest < BaseModelTest
  def new
    return Location.new
  end

  test "latitude expected to be set" do
    instance = new
    has_key(instance, :latitude)
    instance.latitude = 1.3
    not_has_key instance, :latitude
  end

  test "longitude expected to be set" do
    instance = new
    has_key(instance, :longitude)
    instance.longitude = 3.2
    not_has_key instance, :longitude
  end

  test "latitude is only numeric, but allows decimals" do
    run_decimal_tests(:latitude);
  end

  test "longitude is only numeric, but allows decimals" do
    run_decimal_tests(:longitude);
  end

  test "name is not required if blank" do
    run_required_if_set_tests :name
  end

  test "validate name bounds enforced" do
    test_cases = ["s", STRING_255, STRING_256]
    expectations = [true, true, false]
    location = locations(:one)
    validate_bounds location, :name, test_cases, expectations
  end

  test "mine should only return locations that belong to the user" do
    user = create_cooked_user
    user.users_locations << create_cooked_user_location
    save user

    assert user.errors.empty?

    locations = Location.mine user
    assert locations
    assert_equal 2, locations.count
  end

  test "have_names should only return locations that have a name set" do
    TEST_CASE = "test"
    user = create_cooked_user
    named_location = create_cooked_location(TEST_CASE)
    user.users_locations << create_cooked_user_location
    user.users_locations << create_cooked_user_location(user, named_location)
    save user

    assert user.errors.empty?

    locations = Location.have_names
    assert locations
    assert_equal 1, locations.count
    assert_equal TEST_CASE, locations[0].name
  end

  test "visible should only return locations that are visible" do
    pre_size = Location.all.size
    user = create_cooked_user
    location = create_cooked_location
    location.visible = false
    user.users_locations << create_cooked_user_location(user, location)
    save user

    assert user.errors.empty?

    locations = Location.only_visible
    assert locations
    assert_equal pre_size + 1, locations.count
    assert_not_equal location.id, locations[pre_size].id
  end
end
