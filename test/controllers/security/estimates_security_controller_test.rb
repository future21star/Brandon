require 'test_helper'

class EstimatesSecurityControllerTest < BaseControllerTest
  setup do
    @esttimate = create_cooked_estimate(create_cooked_quote(get_business))
    save @esttimate
    assert @esttimate.errors.empty?
    @controller = EstimatesController.new
  end

  test "my_estimates should only be accessible to expected roles" do
    role = ROLE_BUSINESS

    run_role_get_security(:my_estimates, my_estimates_json, role)
  end
end
