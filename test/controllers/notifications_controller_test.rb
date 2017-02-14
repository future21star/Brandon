require 'test_helper'

class NotificationsControllerTest < BaseControllerTest
  setup do
    @notification = notifications(:one)
    user_sign_in
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:notifications)
  end

  test "should get new" do
    admin_sign_in
    get :new
    assert_response :success
  end

  test "should create notification" do
    skip
    assert_difference('Notification.count') do
      post :create, notification: { delivery_type: @notification.delivery_type, seen: @notification.seen,
                                    notification_template_id: @notification.notification_template_id,
                                    user_id: @notification.user_id }
    end

    assert_redirected_to notification_path(assigns(:notification))
  end

  test "should show notification" do
    get :show, id: @notification
    assert_response :success
  end

  test "should get edit" do
    admin_sign_in
    get :edit, id: @notification
    assert_response :success
  end

  test "should update notification" do
    skip
    patch :update, id: @notification, notification: { delivery_type: @notification.delivery_type, seen: @notification.seen, notification_template_id: @notification.notification_template_id, user_id: @notification.user_id }
    assert_redirected_to notification_path(assigns(:notification))
  end
end
