require 'test_helper'

class LocationsSecurityControllerTest < BaseControllerTest
  setup do
    @controller = LocationsController.new
    @location = get_user.locations[0]
  end

  test "update should only be accessible to expected roles" do
    args = location_json
    args[:id] = @location.id
    args[:format] = :json
    run_role_patch_security(:update, args, ROLE_USER)
  end

  test "my_locations should only be accessible to expected roles" do
    role = ROLE_USER

    run_role_get_security(:my_locations, {:format => :json}, role)
  end
end
