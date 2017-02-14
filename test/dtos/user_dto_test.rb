require 'test_helper'

class UserDTOTest < BaseModelTest
  test "Create DTO from instance should be as expected" do
    instance = create_cooked_user
    instance.save

    dto = UserDTO.instance_to_hash(instance)
    assert_not_nil dto
    assert_not_nil dto[:id]
    assert_not_nil dto[:first_name]
    assert_equal instance.first_name, dto[:first_name]
    assert_not_nil dto[:last_name]
    assert_equal instance.last_name, dto[:last_name]
    assert_not_nil dto[:full_name]
    assert_equal instance.full_name, dto[:full_name]
    assert_not_nil dto[:email]
    assert_equal instance.email, dto[:email]
    assert_not_nil dto[:picture]
    assert dto[:picture].include?('profile-pic');
  end
end
