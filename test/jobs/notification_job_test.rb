require 'test_helper'

class NotificationJobTest < BaseModelTest

  def new
    return NotificationJob.new
  end

  def params(notification_template_id=1, user_id=1)
    return [{"notification_template_id" => notification_template_id, "user_id" => user_id}]
  end

  test "notification_template_id is required to create job" do
    test_cases = [nil, {}]
    test_cases.each { |test_case|
      exception = assert_raise(ArgumentError) {
        NotificationJob.enqueue test_case, 1
      }
      assert exception
      assert exception.message.downcase.include?("missing required parameter {notification_template_id}"),
             "Test case: #{test_cases}. e: #{exception}"
    }
  end

  test "user_id is required to create job" do
    test_cases = [nil, {}]
    test_cases.each { |test_case|
      exception = assert_raise(ArgumentError) {
        NotificationJob.enqueue 1, test_case
      }
      assert exception
      assert exception.message.downcase.include?("missing required parameter {user_id}"),
             "Test case: #{test_cases}. e: #{exception}"
    }
  end

  test "finding a template is required on perform" do
      assert_raise(ActiveRecord::RecordNotFound) {
        NotificationJob.perform params(-1)
    }
  end

  test "finding a user is required on perform" do
      assert_raise(ActiveRecord::RecordNotFound) {
        NotificationJob.perform params(1)
    }
  end

  test "enqueuing jobs should succeed" do
    Resque.instance_eval do
      def enqueue(klass, *args)
        return true
      end
    end
    assert NotificationJob.enqueue(1, 1)
  end

  test "Happy path should finish and notify" do
    user = create_cooked_user(true)
    save user
    user_id = user.id
    notification_template = notification_templates(:one)
    pre_notification_count = Notification.count
    pre_delivers_count = QuotrMailer.deliveries.count
    assert NotificationJob.perform(params(notification_template.id, user_id))

    notification = Notification.last
    assert notification
    assert notification.id
    assert_equal user_id, notification.user_id
    assert_not_same pre_notification_count, Notification.count
    assert_not_same pre_delivers_count, QuotrMailer.deliveries.count, "Doesn't appear an email was sent"
  end
end
