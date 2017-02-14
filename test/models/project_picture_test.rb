require 'test_helper'

class ProjectPictureTest <  BaseModelTest
  def new
    return ProjectPicture.new
  end

  test "picture expected to be set" do
    instance = new
    has_key(instance, :picture)
    instance.picture = Picture.first
    not_has_key instance, :picture
  end

  test "default picture query should return correct and only 1 picture" do
    project = create_cooked_project
    project_picture = ProjectPicture.new :picture => create_cooked_picture(project.user)
    project.project_pictures << project_picture
    project.publish!

    assert project.id
    result = ProjectPicture.default_picture project
    assert result
    assert result.id
    expected = project.project_pictures[0].id
    assert_equal expected, result.id
    assert_equal result.picture_id, project.project_summary.picture_id

    expected = project.project_pictures[1].id
    project.project_pictures[1].update_attribute(:default, true)
    result = ProjectPicture.default_picture project
    assert result
    assert result.id
    assert_equal expected, result.id

    summary = ProjectSummary.find_by_project_id(project.id)
    assert summary
    assert_equal result.picture_id, summary.picture_id
  end


  test "should be able to change default if project doesn't have a summary" do
    project = create_cooked_project
    project_picture = ProjectPicture.new :picture => create_cooked_picture(project.user)
    project.project_pictures << project_picture
    project.save

    assert project.id
    assert project.draft?
    result = ProjectPicture.default_picture project
    assert result
    assert result.id
    expected = project.project_pictures[0].id
    assert_equal expected, result.id
  end


  test "project can only have 1 default image expected to be set" do
    instance = new
    user = create_cooked_user
    picture1 = create_cooked_picture user
    instance.project = Project.last
    instance.picture = picture1
    instance.default = true
    instance.save
    first_id = instance.id

    assert first_id
    assert instance.picture
    assert instance.picture.id

    picture2 = create_cooked_picture user
    instance = new
    instance.project = Project.last
    instance.picture = picture2
    instance.default = true
    instance.save
    second_id = instance.id

    assert second_id
    queried_out = ProjectPicture.find_by_id(second_id)
    assert queried_out
    assert queried_out.default

    queried_out = ProjectPicture.find_by_id(first_id)
    assert queried_out
    assert !queried_out.default

    picture3 = create_cooked_picture user
    instance = new
    instance.project = Project.last
    instance.picture = picture3
    instance.save
    third_id = instance.id

    assert third_id
    # validate that our second picture is still the default
    queried_out = ProjectPicture.find_by_id(second_id)
    assert queried_out
    assert queried_out.default
  end
end
