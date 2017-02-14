require 'test_helper'

class AddressesControllerTest < BaseControllerTest
  setup do
    @address = Address.first
    loc = Location.find_by_address_id(@address.id)
    user = loc.users_locations[0].user
    sign_in user
  end

  test "create should create" do
    skip("Don't think we'll be using this guy")
    assert_difference('Address.count') do
      post :create, address_create_json
    end
    assert_response :created
  end

  test "update should update as expected" do
    street = "Mayview Cres"
    house_number = "301"
    apartment = "b"
    city = "Waterloo"
    province = Province.find_by_code('ON').id
    postal_code = "n2v1p5"

    pre_change_location = @address.location.id
    pre_change_user_locs = @address.user.users_locations.size

    args = address_update_json(street, house_number, apartment, city, postal_code, province)
    args[:id] = @address.id
    args[:format] = :json
    patch :update, args
    assert_response :ok

    @address.reload
    assert_equal  street, @address.street_name
    assert_equal  house_number, @address.house_number
    assert_equal  apartment, @address.apartment
    assert_equal  city, @address.city
    assert_equal  postal_code.upcase, @address.postal_code
    assert_equal  province, @address.province.id

    #   assert relations
    assert_not_nil @address.location
    assert_not_equal pre_change_location, @address.location.id
    assert_not_nil @address.user
    assert_not_nil @address.user.users_locations
    assert_equal pre_change_user_locs + 1, @address.user.users_locations.size
    assert_equal @address.user.users_locations[pre_change_user_locs].location.id, @address.location.id
  end
end
