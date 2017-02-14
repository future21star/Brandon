require 'test_helper'

class NotificationTemplatesControllerTest < BaseControllerTest
  setup do
    @notification_template = notification_templates(:one)
    admin_sign_in
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:notification_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create notification_template" do
    assert_difference('NotificationTemplate.count') do
      post :create, notification_template: { body_key: @notification_template.body_key,
                                 summary_key: DateTime.now.to_s,
                                 classification: @notification_template.classification,
                                 preference_id: Preference.first}
    end

    assert_redirected_to notification_template_path(assigns(:notification_template))
  end

  test "should show notification_template" do
    get :show, id: @notification_template
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @notification_template
    assert_response :success
  end

  test "should update notification_template" do
    patch :update, id: @notification_template, notification_template: { body_key: @notification_template.body_key, summary_key: @notification_template.summary_key, classification: @notification_template.classification }
    assert_redirected_to notification_template_path(assigns(:notification_template))
  end
end
