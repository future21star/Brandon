require 'test_helper'

class PreferencesControllerTest < BaseControllerTest
  setup do
    @user_preference = get_user.user_preferences[0]
    user_sign_in
  end

  test "should update preference" do
    email = @user_preference.email
    internal = @user_preference.internal

    args = user_preference_json(@user_preference, !email, !internal)
    args[:id] = @user_preference

    patch :update, args
    assert_response :ok

    @user_preference.reload
    assert_equal !email, @user_preference.email
    assert_equal !internal, @user_preference.internal
  end
end
