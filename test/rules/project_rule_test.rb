require 'test_helper'

class ProjectRuleTest <  BaseModelTest
  test "owner of project should be set" do
    project = create_cooked_project
    save project

    rules = ProjectAccessRules.new(project, project.user)
    assert_not_nil rules
    assert rules.is_project_owner
  end

  test "different owner of project should not be set" do
    other_user = create_cooked_user
    project = create_cooked_project
    save project

    rules = ProjectAccessRules.new(project, other_user)
    assert_not_nil rules
    assert !rules.is_project_owner
  end

  test "business owner of project should be set" do
    user = create_cooked_business_user
    save user
    project = create_cooked_project(user)
    save project

    rules = ProjectAccessRules.new(project, user)
    assert_not_nil rules
    assert rules.is_business_user
  end

  test "non-business owner of project should not be set" do
    project = create_cooked_project
    save project

    rules = ProjectAccessRules.new(project, project.user)
    assert_not_nil rules
    assert !rules.is_business_user
  end

  test "Project access rules with null (not logged in) user should not crash" do
    project = create_cooked_project
    save project

    rules = ProjectAccessRules.new(project, nil)
    assert_not_nil rules
    assert !rules.is_business_user
    assert !rules.is_project_owner
  end

  test "Only logged in, non-owners of the project can report spam" do
    project = create_cooked_project
    project.publish!

    rules = ProjectAccessRules.new(project, nil)
    assert_not_nil rules
    assert !rules.can_report

    rules = ProjectAccessRules.new(project, project.user)
    assert_not_nil rules
    assert !rules.can_report

    rules = ProjectAccessRules.new(project, create_cooked_user)
    assert_not_nil rules
    assert rules.can_report
  end
end
