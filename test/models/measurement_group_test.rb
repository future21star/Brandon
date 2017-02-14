require 'test_helper'

class MeasurementGroupTest < BaseModelTest
  def new
    return MeasurementGroup.new
  end

  test "name expected to be set" do
    instance = new
    has_key(instance, :name)
    instance.name = 'test'
    not_has_key instance, :name
  end

  test "validate name bounds enforced" do
    test_cases = [create_string(5), create_string(100), create_string(1), create_string(101)]
    expectations = [true, true, false, false]
    project = create_cooked_project
    validate_bounds project.measurement_groups[0], :name, test_cases, expectations
  end

  test "group_id expected to be set" do
    instance = new
    has_key(instance, :group_id)
    instance.group_id = 1
    not_has_key instance, :group_id
  end

  test "order expected to be set" do
    instance = new
    instance.order = nil
    has_key(instance, :order)
    instance.order = 0
    not_has_key instance, :order
  end

  test "Destroy should re-order existing measurement groups" do
    project = create_cooked_project
    pre_count = project.measurement_groups.size
    project.measurement_groups << create_cooked_measurement_group(project)
    project.measurement_groups << create_cooked_measurement_group(project)
    project.measurement_groups << create_cooked_measurement_group(project)
    project.measurement_groups << create_cooked_measurement_group(project)
    save project
    assert project.errors.empty?

    # delete a group in the middle
    project.measurement_groups[pre_count + 1].destroy.errors

    project.reload
    assert_not_equal pre_count, project.measurement_groups.size
    count = 0
    project.measurement_groups.each { |group|
      assert_equal count, group.group_id, "Group ordering is no sequential"
      assert_equal count, group.order, "Group ordering is no sequential"
      count += 1
    }
  end

  test "Measurement group must have at least 1 measurement to persist" do
    group= create_cooked_measurement_group(create_cooked_project)
    group.measurements = []
    save group

    assert !group.errors.empty?

    group.measurements << create_cooked_measurement(group)
    save group

    assert group.errors.empty?
  end

  test "When updating should enforce constraints" do
    group= create_cooked_measurement_group(create_cooked_project)
    group.measurements << create_cooked_measurement(group)
    save group
    assert_not_nil group.id

    group.measurements = []
    save group

    assert !group.errors.empty?
  end

  test "Cannot destroy every measurement group from a project" do
    project = create_cooked_project
    group= create_cooked_measurement_group(project)
    group.measurements << create_cooked_measurement(group)
    save group
    assert_not_nil group.id

    project.measurement_groups[0].destroy
    assert !project.measurement_groups[0].errors.empty?
  end
end
