require 'test_helper'

class PasswordsSecurityControllerTest < BaseControllerTest
  setup do
    @controller = Users::PasswordsController.new
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  def redirected_reset_properly(user, args, verb)
    if user
      assert_redirected_to :terms_and_conditions
    else
      assert_redirected_to :new_user_session
    end
  end

  def redirected_properly(user, args, verb)
    if user
      assert_redirected_to :terms_and_conditions
    else
      assert_response :ok
    end
  end

  test "create should only be accessible to expected roles" do
    args = {user: {email: "t@t.cpom"}, commit: "Send me reset password instructions"}
    run_role_post_security(:create, args, nil, method(:redirected_reset_properly))
  end

  test "edit should only be accessible to expected roles" do
    run_role_get_security(:edit, {reset_password_token: 'aaa'}, nil, method(:redirected_properly))
  end

  test "new should only be accessible to expected roles" do
    run_role_get_security(:new, {}, nil, method(:redirected_properly))
  end

  test "update should only be accessible to expected roles" do
    run_role_patch_security(:update, {}, nil, method(:redirected_properly))
  end
end
