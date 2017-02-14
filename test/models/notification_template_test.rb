require 'test_helper'

class NotificationTemplateTest < BaseModelTest
  def new
    return NotificationTemplate.new
  end

  test "summary_key expected to be set" do
    instance = new
    has_key(instance, :summary_key)
    instance.summary_key = "summary key"
    not_has_key instance, :summary_key
  end

  test "body_key expected to be set" do
    instance = new
    has_key(instance, :summary_key)
    instance.body_key = "body_key"
    not_has_key instance, :body_key
  end

  test "classification expected to be set" do
    instance = new
    has_key(instance, :classification)
    instance.classification = 1
    not_has_key instance, :classification
  end

  test "preference expected to be set" do
    instance = new
    has_key(instance, :preference)
    instance.preference = Preference.first
    not_has_key instance, :preference
  end

  test "Submission should persist the data" do
    instance = create_cooked_notification_template
    save instance

    assert_equal true, instance.errors.empty?
    assert instance.id
  end
end
