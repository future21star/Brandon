require 'test_helper'

class ProjectSummaryTest < BaseModelTest
  def new
    return ProjectSummary.new
  end

  test "project expected to be set" do
    instance = new()
    has_key(instance, :project)
    instance.project = Project.first
    not_has_key instance, :project
  end

  test "latitude expected to be set" do
    instance = new()
    has_key(instance, :latitude)
    instance.latitude = -20
    not_has_key instance, :latitude
  end

  test "longitude expected to be set" do
    instance = new()
    has_key(instance, :longitude)
    instance.longitude = -32
    not_has_key instance, :longitude
  end

  test "title expected to be set" do
    instance = new()
    has_key(instance, :title)
    instance.title = 'Great title'
    not_has_key instance, :title
  end

  test "picture_url expected to be set" do
    instance = new()
    has_key(instance, :picture_url)
    instance.picture_url = 'Picture url'
    not_has_key instance, :picture_url
  end

  test "Summaries with specific tags" do
    instance = create_cooked_project
    save instance
    instance.publish!
    assert instance.id

    tags = []
    instance.project_tags.each { |project_tag| tags << project_tag.tag }

    assert ProjectSummary.by_tag(tags[0]).first
    assert ProjectSummary.by_tag(tags[1]).first
    assert ProjectSummary.by_tag(tags).first
    assert_equal 0, ProjectSummary.by_tag([]).count
    assert ProjectSummary.by_tag(tags[1]).first
  end

  test "Queried object should have access to its attributes" do
    instance = create_cooked_project
    save instance
    instance.publish!
    assert instance.id

    retrieved = ProjectSummary.find_by_project_id(instance.id)
    assert retrieved
    assert_equal instance.id, retrieved.project_id
  end

  test "In range should return summaries close" do
    instance = create_cooked_project
    instance.publish!
    assert instance.id

    #create close one
    close = create_cooked_project(instance.user)
    close.location.latitude -= 0.001
    close.publish!
    assert close.id

    far = create_cooked_project(instance.user, create_cooked_location(nil, 44))
    far.publish!
    assert far.id

    summary = instance.project_summary
    assert summary
    assert summary.id
    latlng= [instance.location.latitude, instance.location.longitude]
    locations = ProjectSummary.in_range latlng
    assert locations
    assert_equal 2, locations.count

    assert_equal summary.latitude, locations[0].latitude
    assert_equal summary.longitude, locations[0].longitude
    assert_equal close.location.latitude, locations[1].latitude
    assert_equal close.location.longitude, locations[1].longitude

  end
end
