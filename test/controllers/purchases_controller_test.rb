require 'test_helper'

class PurchasesControllerTest < BaseControllerTest
  setup do
    @purchase = purchases(:one)
    business_sign_in
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:purchases)
  end

  test "should get new" do
    get :new, {package: {id: Package.first.id}}
    assert_response :success
  end

  test "should create purchase" do
    skip "Need to mock out the stripe API call"
    assert_difference('Purchase.count') do
      post :create, purchase: { quantity: @purchase.quantity, price_per_unit: 23, transaction_id: @purchase.transaction_id, user_id: @purchase.user_id }
    end

    assert_redirected_to purchase_path(assigns(:purchase))
  end

  test "list_packages should list packages" do
    all = Package.all

    get :list_packages
    packages = assigns(:packages)
    assert_not_nil packages
    assert_equal all.size, packages.size
    assert_response :success
  end

end
