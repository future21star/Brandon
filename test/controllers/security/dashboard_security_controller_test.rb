require 'test_helper'

class DashboardsSecurityControllerTest < BaseControllerTest
  setup do
    @controller = DashboardsController.new
  end

  test "dashboard should only be accessible to expected roles" do
    run_role_get_security(:dashboard, {}, ROLE_USER)
  end
end
