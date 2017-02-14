require 'test_helper'

class AddressDTOTest < BaseModelTest
  test "Create DTO from instance should be as expected" do
    instance = create_cooked_address
    instance.save

    dto = AddressDTO.instance_to_hash(instance)
    assert_not_nil dto
    assert_not_nil dto[:id]
    assert_equal instance.id, dto[:id]
    assert_not_nil dto[:house_number]
    assert_equal instance.house_number, dto[:house_number]
    assert_not_nil dto[:street_name]
    assert_equal instance.street_name, dto[:street_name]
    assert_not_nil dto[:postal_code]
    assert_equal instance.postal_code, dto[:postal_code]
    assert_not_nil dto[:apartment]
    assert_equal instance.apartment, dto[:apartment]
    assert_not_nil dto[:city]
    assert_equal instance.city, dto[:city]
    assert_not_nil dto[:province]
    assert_equal instance.province_id, dto[:province]
    assert_not_nil dto[:country]
    assert_equal instance.province.country.id, dto[:country]

  end
end
