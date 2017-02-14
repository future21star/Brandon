require 'test_helper'

class LocationDTOTest < BaseModelTest
  test "Create DTO from instance should be as expected" do
    instance = create_cooked_location("name")
    instance.save

    dto = LocationDTO.instance_to_hash(instance)
    assert_not_nil dto
    assert_not_nil dto[:latitude]
    assert_equal instance.latitude, dto[:latitude]
    assert_not_nil dto[:longitude]
    assert_equal instance.longitude, dto[:longitude]
    assert_not_nil dto[:visible]
    assert_equal instance.visible, dto[:visible]
    assert_not_nil dto[:name]
    assert_equal instance.name, dto[:name]

  end
end
