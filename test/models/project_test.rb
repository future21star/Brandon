require 'test_helper'

class ProjectTest < BaseModelTest
  def new
    return Project.new
  end

  test "user expected to be set" do
    instance = new()
    has_key(instance, :user)
    instance.user = User.first
    not_has_key instance, :user
  end

  test "project_tags expected to be set" do
    instance = new()
    has_key(instance, :project_tags)
    instance.project_tags << ProjectTag.first
    not_has_key instance, :project_tags
  end

  test "summary expected to be set" do
    instance = new()
    has_key(instance, :summary)
    instance.summary = "This is a projects usmmary"
    not_has_key instance, :summary
  end

  test "title expected to be set" do
    instance = new()
    has_key(instance, :title)
    instance.title = "This is a projects title"
    not_has_key instance, :title
  end

  test "description expected to be set" do
    instance = new()
    has_key(instance, :description)
    instance.description = "test description that needs to be so long that it doesn't trigger " \
        "the other validations. If you want a great result, write a great description"
    not_has_key instance, :description
  end

  test "pictures must be set expected to be set" do
    instance = new()
    has_key(instance, :project_pictures)
    instance.project_pictures << ProjectPicture.first
    not_has_key instance, :project_pictures
  end

  test "location must be set expected to be set" do
    instance = new()
    has_key(instance, :location)
    instance.location = Location.first
    not_has_key instance, :location
  end

  test "measurement_groups must be set expected to be set" do
    instance = new
    has_key(instance, :measurement_groups)
    instance.measurement_groups << MeasurementGroup.first
    not_has_key instance, :measurement_groups
  end

  test "validate summary bounds enforced" do
    test_cases = [create_string(5), create_string(250), create_string(4), create_string(251)]
    expectations = [true, true, false, false]
    validate_bounds create_cooked_project, :summary, test_cases, expectations
  end

  test "validate title bounds enforced" do
    test_cases = [create_string(5), create_string(100), create_string(4), create_string(101)]
    expectations = [true, true, false, false]
    validate_bounds create_cooked_project, :title, test_cases, expectations
  end

  test "validate description bounds enforced" do
    test_cases = [create_string(100), create_string(150), create_string(4), create_string(99)]
    expectations = [true, true, false, false]
    validate_bounds create_cooked_project, :description, test_cases, expectations
  end

  test "When submitting a project, the whole structure should be created" do
    project = create_cooked_project
    save project

    assert_equal true, project.errors.empty?
    assert project.id
    assert project.project_meta_datum
    assert project.project_meta_datum.id
    assert project.project_tags
    assert project.project_tags[0].id
    assert_equal project.project_tags[0].id, project.project_tags[0].id
    assert project.project_tags[1].id
    assert_equal project.project_tags[1].id, project.project_tags[1].id
    assert project.tags
    assert project.tags[0].id
    assert project.tags[1].id
    assert project.project_pictures
    assert project.project_pictures[0].id
    assert project.project_pictures[0].picture
    assert project.project_pictures[0].picture.id
    assert project.pictures
    assert project.pictures[0].id
    assert_equal project.project_pictures[0].picture.id, project.pictures[0].id
    assert project.measurement_groups
    assert project.measurement_groups[0].id
    assert project.measurement_groups[0].measurements
    assert project.measurement_groups[0].measurements[0].value
    assert_equal 321.2, project.measurement_groups[0].measurements[0].value
    assert project.measurement_groups[0].measurements[1].value
    assert_equal 432.1, project.measurement_groups[0].measurements[1].value

    assert !project.project_summary

    project.publish!
    assert project.project_summary
  end

  test "first picture should be set as default without user having to specify it" do
    instance = create_cooked_project
    project_picture = ProjectPicture.new :picture => create_cooked_picture(instance.user)
    instance.project_pictures << project_picture
    instance.save

    assert instance.id
    assert instance.project_pictures[0].default?
    assert !instance.project_pictures[1].default?
  end

  test "When project published then closed, should have proper summaries" do
    instance = create_cooked_project
    save instance
    assert instance.id

    summary = ProjectSummary.find_by_project_id instance.id
    assert !summary

    instance.publish!
    summary = ProjectSummary.find_by_project_id instance.id
    assert summary
    assert summary.id
    assert instance.project_summary

    instance.close!
    summary = ProjectSummary.find_by_project_id instance.id
    assert !summary

    instance.accepted!
    summary = ProjectSummary.find_by_project_id instance.id
    assert !summary
  end

  test "When project published then cancelled, should have proper summaries" do
    instance = create_cooked_project
    save instance
    assert instance.id

    summary = ProjectSummary.find_by_project_id instance.id
    assert !summary

    instance.publish!
    summary = ProjectSummary.find_by_project_id instance.id
    assert summary
    assert summary.id
    assert instance.project_summary

    instance.cancel!
    summary = ProjectSummary.find_by_project_id instance.id
    assert !summary
  end

  test "Mine_should_return_only_my_projects" do
    first = Project.first
    assert_not_nil first
    me = users(:two)
    assert_not_nil me
    assert_not_same first.user.id, me.id
    project1 = create_cooked_project(me)
    project2 = create_cooked_project(me)
    save project1
    assert_not_nil project1.id
    save project2
    assert_not_nil project2.id

    results = Project.mine(me)
    assert_not_nil results
    assert_equal 2, results.size
    results.each { |result|
      assert_equal me.id, result.user_id
    }
  end

  test "summary scope should return only the latest" do
    expected = 5
    user = User.first
    (expected+1).times.each{
      save create_cooked_project(user)
    }

    results = Project.summary(user)
    assert_not_nil results
    assert_same expected, results.length
  end
end
