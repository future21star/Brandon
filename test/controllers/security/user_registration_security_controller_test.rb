require 'test_helper'

class UserRegistrationSecurityControllerTest < BaseControllerTest
  setup do
    @controller = Users::RegistrationsController.new
    devise_user_mapping
  end

  def redirected_properly_on_new(user, args, verb)
    if user
      assert_response :redirect
    elsif verb == 'post'
      assert_response :created
    else
      assert_response :ok
    end
  end

  test "completed should only be accessible to expected roles" do
    run_role_get_security(:completed, {id: User.first.id})
  end

  test "create should only be accessible to expected roles" do
    args = user_create_json
    run_role_post_security(:create, args, nil, method(:redirected_properly_on_new))
  end

  test "new should only be accessible to expected roles" do
    run_role_get_security(:new, {}, nil, method(:redirected_properly_on_new))
  end

  test "edit should only be accessible to expected roles" do
    run_role_get_security(:edit, {}, ROLE_USER)
  end

  test "update should only be accessible to expected roles" do
    args = user_update_json
    run_role_patch_security(:update, args, ROLE_USER)
  end
end
