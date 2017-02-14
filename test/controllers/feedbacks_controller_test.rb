require 'test_helper'

class FeedbacksControllerTest < BaseControllerTest
  setup do
    @feedback = feedbacks(:one)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create feedback" do
    assert_difference('Feedback.count') do
      post :create, feedback: { content: @feedback.content, email: @feedback.email, name: @feedback.name }
    end

    assert_response :created
  end

  test "should get completed" do
    get :completed
    assert_response :success
  end
end
