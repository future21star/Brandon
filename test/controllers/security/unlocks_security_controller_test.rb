require 'test_helper'

class UnlocksSecurityControllerTest < BaseControllerTest
  setup do
    @controller = Users::ConfirmationsController.new
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  def redirected_properly(user, args, verb)
    assert_redirected_to :new_user_session
  end

  test "create should only be accessible to expected roles" do
    args = {user: {email: "t@t.cpom"}, commit: "Send me reset password instructions"}
    run_role_post_security(:create, args, nil, method(:redirected_properly))
  end

  test "new should only be accessible to expected roles" do
    run_role_get_security(:new)
  end

  test "show should only be accessible to expected roles" do
    run_role_get_security(:show, {reset_password_token: 'aaa'})
  end
end
