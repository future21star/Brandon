require 'test_helper'

class PromoCodesSecurityControllerTest < BaseControllerTest
  setup do
    @code = promo_codes(:one)
    @code.end_date = Time.now + 1.day
    save @code
    assert @code.id
    @controller = PromoCodesController.new
  end

  test "cancel should only be accessible to expected roles" do
    run_role_patch_security(:cancel, {id: @code.id}, ROLE_ADMIN)
  end

  test "create should only be accessible to expected roles" do
    args = valid_promo_code_json(@code)
    run_role_post_security(:create, args, ROLE_ADMIN)
  end

  test "destroy should only be accessible to expected roles" do
    args = {id: @code.id, format: 'json'}
    run_role_delete_security(:destroy, args, ROLE_ADMIN)
  end

  test "edit should only be accessible to expected roles" do
    run_role_get_security(:edit, {id: @code.id}, ROLE_ADMIN)
  end

  test "index should only be accessible to expected roles" do
    run_role_get_security(:index, {}, ROLE_ADMIN)
  end

  test "new should only be accessible to expected roles" do
    run_role_get_security(:new, {}, ROLE_ADMIN)
  end

  test "show should only be accessible to expected roles" do
    run_role_get_security(:show, {id: @code.id}, ROLE_ADMIN)
  end

  test "update should only be accessible to expected roles" do
    args = valid_promo_code_json(@code)
    args[:id] = @code.id
    args[:format] = 'json'
    run_role_patch_security(:update, args, ROLE_ADMIN)
  end

  test "validate_promo_code should only be accessible to expected roles" do
    run_role_get_security(:validate_promo_code, {promo_code: valid_promo_code_json(@code)}, ROLE_BUSINESS)
  end

end
