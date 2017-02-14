require 'test_helper'

class LandingPageSecurityControllerTest < BaseControllerTest
  setup do
    @controller = LandingPageController.new
  end

  test "index should only be accessible to expected roles" do
    run_role_get_security(:index)
  end
end
