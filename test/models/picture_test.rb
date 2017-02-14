require 'test_helper'

class PictureTest < BaseModelTest
  def new
    return Picture.new
  end

  test "filename expected to be set" do
    instance = new
    has_key(instance, :a)
    instance.a_file_name = "test"
    not_has_key instance, :a
  end

  test "generated_name expected to be set" do
    instance = new
    has_key(instance, :generated_name)
    instance.generated_name = "asdase2"
    not_has_key instance, :generated_name
  end

  test "user expected to be set" do
    instance = new
    has_key(instance, :user)
    instance.user = User.first
    not_has_key instance, :user
  end

  test "Submit picture should persist whole structure" do
    instance = create_cooked_picture
    instance.save
    assert instance.id
  end

  test "Picture cannot be deleted if it is associated with a project" do
      project = create_cooked_project
      project.save
      puts "errors: #{project.errors.keys}"
      picture =  project.project_pictures[0].picture
      picture.destroy

      puts "picture errors: #{picture.errors.keys}"
      assert picture.errors
      assert picture.errors[:project_pictures]

      picture.errors.clear

      picture.project_pictures.destroy_all
      picture.destroy
      assert picture.errors.empty?, picture.errors.full_messages
  end
end
