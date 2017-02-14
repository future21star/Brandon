require 'test_helper'

class ProjectDTOTest < BaseModelTest
  test "Create DTO from project should be as expected" do
    instance = create_cooked_project
    save instance
    instance.publish

    dto = ProjectDTO.instance_to_hash(instance)
    assert_not_nil dto
    assert_not_nil dto[:id]
    assert_equal instance.id, dto[:id]
    assert_not_nil dto[:title]
    assert_equal instance.title, dto[:title]
    assert_not_nil dto[:published]
    assert_equal instance.published_at, dto[:published]
    assert_not_nil dto[:summary]
    assert_equal instance.summary, dto[:summary]
    assert_not_nil dto[:description]
    assert_equal instance.description, dto[:description]
    assert_not_nil dto[:state]
    assert_equal 'published', dto[:state]
    assert_not_nil dto[:location][:id]
    assert_equal instance.location.id, dto[:location][:id]
    assert_not_nil dto[:location][:latitude]
    assert_equal instance.location.latitude, dto[:location][:latitude]
    assert_not_nil dto[:location][:longitude]
    assert_equal instance.location.longitude, dto[:location][:longitude]
    assert_not_nil dto[:tags]
    assert_equal "Kitchen", dto[:tags].fetch(0)[:name]
    assert_not_nil dto[:images]
    assert_equal "tiger.jpg", dto[:images].fetch(0)[:file_name]
    assert_not_nil dto[:measurement_groups]
    assert_equal instance.measurement_groups[0].name, dto[:measurement_groups].fetch(0)[:name]
    assert_not_nil dto[:measurement_groups].fetch(0)[:measurements_attributes]
    assert_equal instance.measurement_groups[0].measurements[0].value,
                 dto[:measurement_groups].fetch(0)[:measurements_attributes].fetch(0)[:value]
  end
end
