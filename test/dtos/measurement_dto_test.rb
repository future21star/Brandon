require 'test_helper'

class MeasurementDTOTest < BaseModelTest
  test "Create DTO from measurement should be as expected" do
    instance = create_cooked_measurement
    save instance

    dto = MeasurementDTO.instance_to_hash(instance)
    assert_not_nil dto
    assert_not_nil dto[:id]
    assert_equal instance.id, dto[:id]
    assert_not_nil dto[:value]
    assert_equal instance.value, dto[:value]
    assert_not_nil dto[:unit_quantifier_id]
    assert_equal instance.unit_quantifier.id, dto[:unit_quantifier_id]
    assert_not_nil dto[:classification_quantifier_id]
    assert_equal instance.classification_quantifier.id, dto[:classification_quantifier_id]
  end
end
