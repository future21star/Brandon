require 'test_helper'

class LocationsControllerTest < BaseControllerTest
  setup do
    @location = locations(:one)
    user_sign_in
  end

  test "should update location" do
    visible = !@location.visible
    name = "ddsada"

    args = location_json(name, visible)
    args[:id] = @location
    patch :update, args
    assert_redirected_to location_path(assigns(:location))

    @location.reload
    assert_equal visible, @location.visible
    assert_equal name, @location.name
  end

  test "my_locations should return my locations" do
    user = get_user
    locations = Location.mine(user)
    locations.each { |loc| loc.name = "t"; loc.save }
    user.reload

    get :my_locations
    location_data = JSON.parse(@response.body).symbolize_keys

    assert_not_nil location_data
    assert_not_nil location_data[:location]
    loc = location_data[:location].symbolize_keys
    assert_equal user.address.location.id, loc[:id]
    assert_not_nil location_data[:locations]
    assert_equal "t", location_data[:locations][0].symbolize_keys[:name]
  end
end
