require 'test_helper'

class PromoCodesControllerTest < BaseControllerTest
  setup do
    @promo_code = promo_codes(:one)
    admin_sign_in
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:promo_codes)
  end

  test "validate_promo_code when not found should return bad request" do
    business_sign_in
    get :validate_promo_code, :promo_code => {:code => '123123', :source => PromoCode::SOURCE_REGISTRATION}
    assert_response :bad_request
  end

  test "validate_promo_code when found should return ok" do
    business_sign_in
    @promo_code.end_date = Time.now + 1.day
    save @promo_code
    assert @promo_code.errors.empty?
    
    get :validate_promo_code, :promo_code => valid_promo_code_json(@promo_code)
    assert_response :ok
  end

  test "should create promo_code" do
    assert_difference('PromoCode.count') do
      post :create, valid_promo_code_json
    end
  end

  test "cancel should cancel promo_code immediately" do
    new_end = Time.now + 1.day
    @promo_code.end_date = new_end
    save @promo_code
    assert @promo_code.errors.empty?

    patch :cancel, :id => @promo_code.id
    assert_response :ok

    code = PromoCode.find(@promo_code.id)
    assert new_end >= code.end_date
  end

  test "should show promo_code" do
    get :show, id: @promo_code
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @promo_code
    assert_response :success
  end
end
