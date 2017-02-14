require 'test_helper'

class CreationHelperTest < BaseControllerTest
  test "create_business should return valid business object for persistance" do
    params = business_user_create_json
    instance = CreationHelper.create_business(params)
    assert_not_nil instance
    assert_nil instance.id
    instance.user = create_cooked_user

    save instance
    assert instance.valid?
    assert instance.id
  end
end
