require 'test_helper'

class SessionSecurityControllerTest < BaseControllerTest
  setup do
    @controller = Users::SessionsController.new
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  def redirected_properly(user, args, verb)
    if verb == 'delete'
      assert_redirected_to :new_user_session
    elsif user
      assert_redirected_to :terms_and_conditions
    else
      assert_response :ok
    end
  end

  test "create should only be accessible to expected roles" do
    run_role_post_security(:create, {}, nil, method(:redirected_properly))
  end

  test "new should only be accessible to expected roles" do
    args = {}
    run_role_get_security(:new, args, nil, method(:redirected_properly))
  end

  test "destroy should only be accessible to expected roles" do
    run_role_delete_security(:destroy, {}, nil, method(:redirected_properly))
  end
end
