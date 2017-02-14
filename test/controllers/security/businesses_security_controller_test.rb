require 'test_helper'

class BusinessesSecurityControllerTest < BaseControllerTest
  setup do
    @controller = BusinessesController.new
  end

  test "create should only be accessible to expected roles" do
    args = business_create_json
    begin
      run_role_post_security(:create, args, ROLE_USER)
    rescue ActiveRecord::RecordNotUnique
      #   This is expected because you can only register once
    end
  end

  test "create_tag should only be accessible to expected roles" do
    run_role_post_security(:create_tag, {tag: {id: Tag.first.id}, format: :json}, ROLE_BUSINESS)
  end

  test "destroy_tag should only be accessible to expected roles" do
    business = get_business.business
    run_role_delete_security(:destroy_tag, {tag: {id: business.tags[0].id}, format: :json}, ROLE_BUSINESS)
  end

  test "update should only be accessible to expected roles" do
    business = get_business.business
    args = business_update_json
    args[:id] = business.id
    args[:format] = :json
    run_role_patch_security(:update, args, ROLE_BUSINESS)
  end

end
