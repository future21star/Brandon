require 'test_helper'

class PreferenceSecurityControllerTest < BaseControllerTest
  setup do
    @user_preference = UserPreference.first
    @controller = PreferencesController.new
  end

  test "update should only be accessible to expected roles" do
    role = ROLE_USER
    args = user_preference_json(@user_preference)
    args[:id] = @user_preference.id

    run_role_patch_security(:update, args, role)
  end
end
