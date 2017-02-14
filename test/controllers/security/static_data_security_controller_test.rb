require 'test_helper'

class StaticDataSecurityControllerTest < BaseControllerTest
  setup do
    @controller = StaticDataController.new
  end

  test "map_data should only be accessible to expected roles" do
    run_role_get_security(:map_data)
  end

  test "captcha_key should only be accessible to expected roles" do
    run_role_get_security(:captcha_key)
  end

  test "get_eula should only be accessible to expected roles" do
    run_role_get_security(:get_eula)
  end
end
