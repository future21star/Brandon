require 'test_helper'

class BusinessDTOTest < BaseModelTest
  test "Create DTO from instance should be as expected" do
    instance = create_cooked_business
    instance.save

    dto = BusinessDTO.instance_to_hash(instance)
    assert_not_nil dto
    assert_not_nil dto[:id]
    assert_equal instance.id, dto[:id]
    assert_not_nil dto[:company_name]
    assert_equal instance.company_name, dto[:company_name]
    assert_not_nil dto[:phone_number]
    assert_equal instance.phone_number, dto[:phone_number]
    assert_not_nil dto[:website]
    assert_equal instance.website, dto[:website]
    assert_not_nil dto[:biography]
    assert_equal instance.biography, dto[:biography]
    assert_not_nil dto[:tags]
    assert_equal instance.tags[0].name, dto[:tags].fetch(0)[:name]
  end
end
