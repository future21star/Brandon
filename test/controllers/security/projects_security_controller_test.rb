require 'test_helper'

class ProjectsSecurityControllerTest < BaseControllerTest
  setup do
    @project = create_cooked_project(get_user)
    save @project
    assert @project.errors.empty?
    @controller = ProjectsController.new
  end

  def validate_redirect_to_project(user, args, verb)
    assert_redirected_to project_path(@project.id)
  end

  test "index should only be accessible to expected roles" do
    run_role_get_security(:index)
  end

  test "search should only be accessible to expected roles" do
    location = Location.first
    args = {lat: location.latitude, lng: location.longitude, tags: "#{Tag.first.id}"}
    run_role_get_security(:search, args)
  end

  test "show should only be accessible to expected roles" do
    run_role_get_security(:show, {id: @project.id})
  end

  test "accept quote should only be accessible to expected roles" do

    role = ROLE_USER
    verb = 'patch'

    expectations = get_role_expectations(role)
    expected_to_accept = expectations[:expected_to_accept]
    expected_to_reject = expectations[:expected_to_reject]

    expected_to_accept.each { |user|
      sign_out_all
      quote = create_cooked_quote(get_business)
      project = quote.project
      save quote
      assert quote.id
      project.close!
      assert project.closed?

      args = {id: project.id, estimate_id: quote.estimates[0].id}
      verb_with_user(verb, :accept_quote, args, user)
      assert_redirected_to project_path(assigns(:project))

      project.reload
      assert project.accepted?
    }

    quote = create_cooked_quote(get_business)
    project = quote.project
    save quote
    assert quote.id
    project.close!
    assert project.closed?

    args = {id: project.id, estimate_id: quote.estimates[0].id}
    expected_to_reject.each { |user|
      sign_out_all
      verb_with_user(verb, :accept_quote, args, user)
      assert_redirected_to new_user_session_path

      project.reload
      assert project.closed?
    }
  end

  test "cancel should only be accessible to expected roles" do
    role = ROLE_USER
    verb = 'patch'

    expectations = get_role_expectations(role)
    expected_to_accept = expectations[:expected_to_accept]
    expected_to_reject = expectations[:expected_to_reject]

    expected_to_accept.each { |user|
      sign_out_all
      project = create_cooked_project(user)
      save project
      assert project.id

      args = {id: project.id}
      verb_with_user(verb, :cancel, args, user)
      assert_redirected_to project_path(assigns(:project))

      project.reload
      assert project.cancelled?
    }

    args = {id: @project.id}
    expected_to_reject.each { |user|
      sign_out_all
      verb_with_user(verb, :cancel, args, user)
      assert_redirected_to new_user_session_path

      @project.reload
      assert @project.draft?
    }
  end

  test "create should only be accessible to expected roles" do
    role = ROLE_USER

    run_role_post_security(:create, project_create_json, role)
  end

  test "create_tag should only be accessible to expected roles" do
    run_role_post_security(:create_tag, {id: @project.id, tag: {id: tags(:unused).id}, format: :json}, ROLE_USER)
  end

  test "delete should only be accessible to expected roles" do
    skip("Most likely going to remove the destroy function")
    role = ROLE_USER
    verb = 'delete'

    expectations = get_role_expectations(role)
    expected_to_accept = expectations[:expected_to_accept]
    expected_to_reject = expectations[:expected_to_reject]

    expected_to_accept.each { |user|
      sign_out_all
      project = create_cooked_project(user)
      save project
      assert project.id

      args = {id: project.id}
      verb_with_user(verb, :destroy, args, user)
      assert_redirected_to project_path(assigns(:project))

      project.reload
      assert project.cancelled?
    }

    args = {id: @project.id}
    expected_to_reject.each { |user|
      sign_out_all
      verb_with_user(verb, :destroy, args, user)
      assert_redirected_to new_user_session_path

      @project.reload
      assert_not_nil @project.id
    }
  end

  test "destroy_tag should only be accessible to expected roles" do
    run_role_delete_security(:destroy_tag, {id: @project.id, tag: {id: @project.tags[0].id}, format: :json}, ROLE_USER)
  end

  test "new should only be accessible to expected roles" do
    role = ROLE_USER

    run_role_get_security(:new, {}, role)
  end

  test "publish should only be accessible to expected roles" do
    role = ROLE_USER
    verb = 'patch'

    expectations = get_role_expectations(role)
    expected_to_accept = expectations[:expected_to_accept]
    expected_to_reject = expectations[:expected_to_reject]

    expected_to_accept.each { |user|
      sign_out_all
      project = create_cooked_project(user)
      save project
      assert project.id
      assert project.draft?

      args = {id: project.id}
      verb_with_user(verb, :publish, args, user)
      assert_redirected_to project_path(assigns(:project))

      project.reload
      assert project.published?
    }

    assert @project.draft?
    args = {id: @project.id}
    expected_to_reject.each { |user|
      sign_out_all
      verb_with_user(verb, :publish, args, user)
      assert_redirected_to new_user_session_path

      @project.reload
      assert @project.draft?
    }
  end

  test "report as spam should only be accessible to expected roles" do
    role = ROLE_USER

    run_role_post_security(:report_as_spam, {id: @project.id}, role, method(:validate_redirect_to_project))
  end

  test "update should only be accessible to expected roles" do
    role = ROLE_USER

    run_role_patch_security(:update, {id: @project, project: project_update_json}, role)
  end

  test "my_projects should only be accessible to expected roles" do
    role = ROLE_USER

    run_role_get_security(:my_projects, my_projects_json, role)
  end
end
