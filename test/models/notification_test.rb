require 'test_helper'

class NotificationTest < BaseModelTest
  def new
    return Notification.new
  end

  test "user expected to be set" do
    instance = new
    has_key(instance, :user)
    instance.user = User.first
    not_has_key instance, :user
  end

  test "notification_template expected to be set" do
    instance = new
    has_key(instance, :notification_template)
    instance.notification_template = NotificationTemplate.first
    not_has_key instance, :notification_template
  end

  test "Notification save should persist data" do
    instance = create_cooked_notification
    save instance

    assert_equal true, instance.errors.empty?
    assert instance.id
  end
end
