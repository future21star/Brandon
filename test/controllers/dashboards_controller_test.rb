require 'test_helper'

class DashboardsControllerTest < BaseControllerTest
  setup do
    business_sign_in
  end

  test "user dashboard should get data" do
    sign_out_all
    user_sign_in
    get :dashboard
    assert_response :success
    assert_not_nil assigns(:latest_projects)
  end

  test "business dashboard should get data" do
    get :dashboard
    assert_response :success
    assert_not_nil assigns(:latest_projects)
    assert_not_nil assigns(:latest_purchases)
    assert_not_nil assigns(:latest_quotes)
  end
end
