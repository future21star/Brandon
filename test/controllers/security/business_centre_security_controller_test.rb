require 'test_helper'

class BusinessCentreSecurityControllerTest < BaseControllerTest
  setup do
    @controller = BusinessCentreController.new
  end

  test "account_search should only be accessible to expected roles" do
    run_role_get_security(:account_search, {}, ROLE_ADMIN)
  end

  test "business_search should only be accessible to expected roles" do
    run_role_get_security(:business_search, {}, ROLE_ADMIN)
  end
end
