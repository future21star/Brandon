require 'test_helper'

class UserPreferenceTest < BaseModelTest
  def new
    return UserPreference.new
  end

  test "user expected to be set" do
    instance = new
    has_key(instance, :user)
    instance.user = User.first
    not_has_key instance, :user
  end

  test "preference expected to be set" do
    instance = new
    has_key(instance, :preference)
    instance.preference = Preference.first
    not_has_key instance, :preference
  end

  test "user can only have one preference of the same type" do
    instance = create_cooked_user
    save instance

    assert_equal true, instance.errors.empty?
    assert instance.id
    assert_raise( ActiveRecord::RecordNotUnique) {
      another = UserPreference.new(preference: Preference.first, user: instance)

      save another
    }
  end
end
