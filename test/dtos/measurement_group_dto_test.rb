require 'test_helper'

class MeasurementGroupDTOTest < BaseModelTest
  test "Create DTO from measurement_group should be as expected" do
    instance = create_cooked_project.measurement_groups[0]
    save instance

    dto = MeasurementGroupDTO.instance_to_hash(instance)

    assert_not_nil dto
    assert_not_nil dto[:id]
    assert_equal instance.id, dto[:id]
    assert_not_nil dto[:name]
    assert_equal instance.name, dto[:name]
    assert_not_nil dto[:group_id]
    assert_equal instance.group_id, dto[:group_id]
    assert_not_nil dto[:order]
    assert_equal instance.order, dto[:order]
    assert_not_nil dto[:measurements_attributes]
    assert_equal instance.measurements[0].value, dto[:measurements_attributes].fetch(0)[:value]
  end
end
