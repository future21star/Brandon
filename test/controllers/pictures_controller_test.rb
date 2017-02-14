require 'test_helper'

class PicturesControllerTest < BaseControllerTest
  setup do
    @picture = create_cooked_picture(get_user)
    save @picture
    user_sign_in
  end

  test "should create" do
    assert_difference('Picture.count') do
      post :create, picture_create_json
    end

    assert_response :created
  end

  test "should destroy" do
    delete :destroy, id: @picture

    assert_response :redirect
    assert_raises(ActiveRecord::RecordNotFound) {
      @picture.reload
    }
  end
  
  test "index should list only mine" do
    admin_sign_in
    get :index
    assert_response :ok
    assert_not_nil assigns(@pictures)
  end

  test "new should setup" do
    get :new
    assert_response :ok
  end
end
