require 'test_helper'

class RegistrationControllerTest < BaseControllerTest
  
  setup do
    @controller = Users::RegistrationsController.new
    devise_user_mapping
  end

  test "completed assigns properly" do
    get :completed, {id: User.first.id}
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "should create user account" do
    assert_difference('User.count') do
      post :create, user_create_json
    end
    assert_response :created
  end

  test "should create business user account" do
    assert_difference('User.count') do
      post :create, business_user_create_json
    end
    assert_response :created
  end

  test "should create business user account with promo code" do
    promo = create_cooked_promo_code
    save promo
    assert promo.id
    assert_difference('User.count') do
      post :create, business_user_create_json(promo)
    end
    assert_response :created
  end

  test "new assigns properly" do
    get :new
    assert_response :success
    assert_not_nil assigns(:business_signup)
    assert_not_nil assigns(:countries)
    assert_not_nil assigns(:provinces)
    assert_not_nil assigns(:source)
  end

  test "edit assigns properly" do
    business_sign_in
    get :edit
    assert_response :success
    assert_not_nil assigns(:user)
    assert_not_nil assigns(:address)
    assert_not_nil assigns(:business)
    assert_not_nil assigns(:preferences)
    assert_not_nil assigns(:tags)
    assert_not_nil assigns(:rules)
  end

  test "update should update account information" do
    first_name = "first"
    last_name = "last"
    email = "c@c.com"
    current_password = "testuser"
    new_password = "ddasdasd3asd"
    user = get_user
    sign_in user
    json = user_update_json(current_password, first_name, last_name, email, new_password)
    put :update, json
    assert_response :ok

    user.reload
    assert_equal first_name, user.first_name
    assert_equal last_name, user.last_name
    assert_equal email, user.unconfirmed_email

    # Try to update again with old password should fail
    put :update, user_update_json
    assert_response :unprocessable_entity
  end

  test "should parse" do
    user = User.new
    user.address = Address.new
    user.validate
    Users::RegistrationsController.new.errors_to_hash(user)
  end
end
