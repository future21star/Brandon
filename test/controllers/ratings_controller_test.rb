require 'test_helper'

class RatingsControllerTest < BaseControllerTest
  setup do
    @rating = ratings(:one)
    user_sign_in
  end

  test "should get index" do
    admin_sign_in
    get :index
    assert_response :success
    assert_not_nil assigns(:ratings)
  end

  test "get_business_ratings should return ratings" do
    @rating = create_cooked_rating
    save @rating
    @rating1 = create_cooked_rating(create_cooked_user, @rating.business)
    save @rating1
    get :get_business_ratings, {:business_id => @rating.business.id, :page => 1}
    assert_response :success
    body = JSON.parse(@response.body)
    assert_not_nil body
    ratings = body['ratings']
    assert_not_nil ratings
    assert_equal @rating.id, ratings[0]['id']
    assert_equal @rating1.id, ratings[1]['id']
  end


  test "should create rating" do
    @rating = @rating.clone

    assert_difference('Rating.count') do
      post :create, rating: { business_id: @rating.business_id, comments: @rating.comments, rating_definition_id: @rating.rating_definition_id, rating: @rating.rating }
    end

  end

  test "should show rating" do
    get :show, id: @rating
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rating
    assert_response :success
  end

  test "should update rating" do
    change = 'new comment'
    patch :update, id: @rating, rating: { business_id: @rating.business_id, comments: change, definition_id: @rating.rating_definition_id, rating: @rating.rating }
    raw = Rating.find_by_id(@rating.id)
    assert_equal change, raw.comments
  end

  test "should destroy rating" do
    sign_in @rating.user
    assert_difference('Rating.count', -1) do
      delete :destroy, id: @rating
    end
  end

  test "should NOT destroy other users rating" do
    second = create_cooked_rating
    save second
    assert_no_difference('Rating.count') do
      delete :destroy, id: second
    end
  end
end
