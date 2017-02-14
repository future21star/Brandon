require 'test_helper'

class FeedbackSecurityControllerTest < BaseControllerTest
  setup do
    @controller = FeedbacksController.new
  end

  test "new should only be accessible to expected roles" do
    run_role_get_security(:new)
  end

  test "create should only be accessible to expected roles" do
    args = feedback_json
    run_role_post_security(:create, feedback: args)
  end

  test "completed should only be accessible to expected roles" do
    run_role_get_security(:completed)
  end
end
