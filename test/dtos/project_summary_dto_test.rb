require 'test_helper'

class ProjectSummaryDTOTest < BaseModelTest
  test "Create DTO from instance should be as expected" do
    instance = create_cooked_project
    instance.save
    instance.publish

    instance = instance.project_summary

    dto = ProjectSummaryDTO.instance_to_hash(instance)
    assert_not_nil dto
    assert_not_nil dto[:id]
    assert_equal instance.id, dto[:id]
    assert_not_nil dto[:project_id]
    assert_equal instance.project_id, dto[:project_id]
    assert_not_nil dto[:title]
    assert_equal instance.title, dto[:title]
    assert_not_nil dto[:latitude]
    assert_equal instance.latitude, dto[:latitude]
    assert_not_nil dto[:longitude]
    assert_equal instance.longitude, dto[:longitude]
    assert_not_nil dto[:picture_id]
    assert_equal instance.picture_id, dto[:picture_id]
    assert_not_nil dto[:picture_url]
    assert_equal instance.picture_url, dto[:picture_url]
  end
end
