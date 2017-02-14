require 'test_helper'

class MeasurementsControllerTest < BaseControllerTest

  def setup
    business_sign_in
    @project = create_cooked_project
    @measurement1 = create_cooked_measurement
    @group = @measurement1.measurement_group
    @measurement2 = create_cooked_measurement(@group)
    @group.measurements << @measurement1
    @group.measurements << @measurement2
    @project.measurement_groups << @group
    save @project

    assert @project.errors.empty?
    assert @group.id
    assert @measurement1.id
    assert @measurement2.id
  end

  def create_measurements_json(measurements=[], values=[])
    measurements_json = []
    measurements.each_index { |i|
      measurement = measurements[i]
       measurements_json << {
           :id => measurement.id, :value => values[i], :unit_quantifier_id => measurement.unit_quantifier.id,
           :classification_quantifier_id => measurement.classification_quantifier.id

       }
    }
    return measurements_json
  end

  test "when existing project adds a new measurement group, should add" do
    pre_size = @project.measurement_groups.size
    name = "new_group"
    measurement_one_value = 1

    post :create_group,
        :project_id => @project.id, :group_id => 100, :order => 100, :name => name, :measurements_attributes =>
                     create_measurements_json([create_cooked_measurement], [measurement_one_value])

    assert_response :success
    raw = Project.find(@project.id)
    assert_not_nil raw
    assert_not_nil raw.measurement_groups
    new_size = raw.measurement_groups.size
    assert_not_same pre_size, new_size
    group = raw.measurement_groups[new_size-1]
    assert_not_nil group
    assert_equal name, group.name
    assert_not_nil group.measurements
    assert_equal 1, group.measurements.size
    measurement = group.measurements[0]
    assert_not_nil measurement
    assert_equal measurement_one_value, measurement.value
  end

  test "when existing measurements should update group" do
    new_name = "group changey"
    measurement_one_value = 22.4
    measurement_two_value = 9.5

    put :update_group, id: @group.id,
          :group_id => @group.group_id, :order => @group.order, :name => new_name, :measurements_attributes =>
              create_measurements_json([@measurement1, @measurement2], [measurement_one_value, measurement_two_value])


    assert_response :success
    raw = MeasurementGroup.find(@group.id)
    assert_not_nil raw
    assert_equal new_name, raw.name
    assert_not_nil raw.measurements
    assert_equal 3, raw.measurements.size
    measurement = raw.measurements[1]
    assert_not_nil measurement
    assert_equal measurement_one_value, measurement.value
    measurement = raw.measurements[2]
    assert_not_nil measurement
    assert_equal measurement_two_value, measurement.value
  end

  test "when new measurement added to group, measurements should update" do
    new_measurement = create_cooked_measurement(@group)
    new_name = "group changey"
    measurement_two_value = 9.5

    put :update_group, id: @group.id,
          :group_id => @group.group_id, :order => @group.order, :name => new_name, :measurements_attributes =>
              create_measurements_json([new_measurement, @measurement2], [new_measurement.value, measurement_two_value])


    assert_response :success
    raw = MeasurementGroup.find(@group.id)
    assert_not_nil raw
    assert_equal new_name, raw.name
    assert_not_nil raw.measurements
    assert_equal 4, raw.measurements.size
    measurement = raw.measurements[2]
    assert_not_nil measurement
    assert_equal measurement_two_value, measurement.value
    measurement = raw.measurements[3]
    assert_not_nil measurement
    assert_equal new_measurement.value, measurement.value
  end

  test "when deleting group, group should destroy" do
    pre_size = @project.measurement_groups.size
    put :destroy_group, id: @group.id

    assert_response :success
    raw = MeasurementGroup.find_by_id(@group.id)
    assert_nil raw
    project = Project.find(@project.id)
    assert_not_nil project
    assert_not_equal pre_size, project.measurement_groups.size
  end

  test "Destroy should destroy measurement included" do
    measurement = create_cooked_measurement
    save measurement
    assert_difference('Measurement.count', -1) do
      delete :destroy, id: measurement.id
    end

    assert_response :ok
    raw = Measurement.find_by_id(measurement.id)
    assert_nil raw
  end

  test "Destroying last measurement should throw validation errors" do
    group = create_cooked_measurement_group(create_cooked_project)
    save group
    assert group.errors.empty?
    measurement = group.measurements[0]
    assert_difference('Measurement.count', 0) do
      delete :destroy, id: measurement.id
    end

    assert_response :unprocessable_entity
    Measurement.find(measurement.id)
    body = JSON.parse(@response.body)
    assert_not_nil body
  end

  test "Destroying last measurement group should throw validation errors" do
    @project.measurement_groups[0].destroy
    assert_difference('MeasurementGroup.count', 0) do
      delete :destroy_group, id: @group.id
    end

    assert_response :unprocessable_entity
    MeasurementGroup.find(@group.id)
    body = JSON.parse(@response.body)
    assert_not_nil body
  end
end
