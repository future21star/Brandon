require 'test_helper'

class ProjectsControllerTest < BaseControllerTest
  setup do
    @project = create_cooked_project(get_user)
    save @project
    assert @project.errors.empty?
    user_sign_in
  end

  test "should get index" do
    sign_out get_user
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    locations_count = get_user.users_locations.size
    assert_difference('Project.count') do
      post :create,
           project_create_json
    end

    assert_response :created

    # Integration test assertions, make sure all associations were created
    project = Project.last
    assert_not_nil project.project_tags
    assert_equal 1, project.project_tags.size
    assert_not_nil project.project_pictures
    assert_equal 1, project.project_pictures.size
    assert_not_nil project.measurement_groups
    assert_equal 1, project.measurement_groups.size
    assert_not_nil project.measurement_groups[0].measurements
    assert_equal 1, project.measurement_groups[0].measurements.size
    assert_not_nil project.user
    assert_not_nil project.user.users_locations
    assert_equal locations_count + 1, project.user.users_locations.size
  end

  test "should show project" do
    sign_out get_user
    get :show, id: @project
    assert_response :success
  end

  test "report_as_spam should create report" do
    assert_difference('SpamReport.count') do
      post :report_as_spam, id: @project
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test "publish should publish project" do
    assert @project.draft?
    post :publish, id: @project

    assert_redirected_to project_path(assigns(:project))

    @project.reload
    assert @project.published?
  end

  test "cancel should cancel project" do
    assert @project.draft?
    post :cancel, id: @project

    assert_redirected_to project_path(assigns(:project))

    @project.reload
    assert @project.cancelled?
  end

  test "accept_quote should accept project" do
    quote = create_cooked_quote(get_business, @project)
    save quote
    assert quote.id
    @project.close!
    assert @project.closed?
    patch :accept_quote, id: @project, estimate_id: quote.estimates[0].id

    assert_redirected_to project_path(assigns(:project))

    @project.reload
    assert @project.accepted?
  end

  test "should update project" do
    new_title = SecureRandom.urlsafe_base64(15)
    new_summary = SecureRandom.urlsafe_base64(15)
    new_desc = SecureRandom.urlsafe_base64(150)
    new_comments = SecureRandom.urlsafe_base64(150)
    patch :update, id: @project, project: project_update_json(new_title, new_summary, new_desc, new_comments)
    assert_response :ok

    @project.reload
    assert_equal new_title, @project.title
    assert_equal new_summary, @project.summary
    assert_equal new_desc, @project.description
    assert_equal new_comments, @project.additional_comments
  end

  test "search should search summaries" do
    sign_out get_user
    1.times {
      project = create_cooked_project
      save project
      assert project.errors.empty?
    }
    location = Location.first
    get :search, {lat: location.latitude, lng: location.longitude, tags: "#{Tag.first.id}"}

    assert_response :success
    assigns(:summaries)
  end


  test "create_tag should create" do
    assert_difference('ProjectTag.count') do
      post :create_tag, {id: @project.id, tag: {id: tags(:unused).id}}
    end
    assert_response :created
  end

  test "create_tag with tag that does not exist should return unprocessable_entity" do
    assert_no_difference('ProjectTag.count') do
      post :create_tag, {id: @project.id, tag: {id: -1}}
    end
    assert_response :unprocessable_entity
  end

  test "destroy_tag should destroy tag" do
    pre_count = @project.tags.size
    tag = @project.tags[0]
    assert_not_nil tag

    delete :destroy_tag, {id: @project.id, tag: {id: tag.id}}
    assert_response :no_content

    @project.reload
    assert_equal pre_count - 1, @project.tags.size
  end

  test "destroy_tag when non-existent should return not_found" do
    tag = tags(:unused)
    assert_not_nil tag

    delete :destroy_tag, {id: @project.id, tag: {id: tag.id}}
    assert_response :not_found

    tag.reload
    assert_not_nil tag
    assert_not_nil tag.id
  end

  test "my_projects should return my projects" do
    @project.user
    get :my_projects, my_projects_json
    assert_response :ok

    other_ver = assigns(:projects)
    assert_not_nil other_ver
    assert !other_ver.empty?
    project = other_ver[0]
    assert_equal @project.id, project.id
  end
end
