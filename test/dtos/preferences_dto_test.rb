require 'test_helper'

class PreferencesDTOTest < BaseModelTest
  test "Create DTO from instanceshould be as expected" do
    instance = create_cooked_user
    save instance

    instance = instance.user_preferences[0]

    dto = PreferencesDTO.instance_to_hash(instance)
    assert_not_nil dto
    assert_not_nil dto[:id]
    assert_not_nil dto[:email]
    assert_equal instance.email, dto[:email]
    assert_not_nil dto[:internal]
    assert_equal instance.internal, dto[:internal]
    assert_not_nil dto[:name]
    assert_equal instance.preference.name, dto[:name]
  end
end
