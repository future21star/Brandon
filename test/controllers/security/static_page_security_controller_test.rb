require 'test_helper'

class StaticPageSecurityControllerTest < BaseControllerTest
  setup do
    @controller = StaticPagesController.new
  end

  test "privacy_policy should only be accessible to expected roles" do
    run_role_get_security(:privacy_policy)
  end

  test "terms_and_conditions should only be accessible to expected roles" do
    run_role_get_security(:terms_and_conditions)
  end
end
