
class NotificationJob < BaseJob

  @logger = MyLogger.factory(self)
  @queue = :notifications
  @class = NotificationJob

  def self.validate_request(notification_template_id, user_id)
    if notification_template_id.blank? or !notification_template_id.is_a? Integer
      raise ArgumentError.new "missing required parameter {notification_template_id}"
    end
    if user_id.blank? or !user_id.is_a? Integer
      raise ArgumentError.new "missing required parameter {user_id}"
    end
  end

  def self.create_params(notification_template_id, user_id)
    return [:notification_template_id => notification_template_id, :user_id => user_id]
  end

  def self.perform(params)
    @logger.info "Performing execution of #{@class} with params: #{params.inspect}"
    notification_template_id = params[0]['notification_template_id']
    user_id = params[0]['user_id']
    validate_request notification_template_id, user_id

    template = NotificationTemplate.find_by_id! notification_template_id
    user = User.find_by_id! user_id
    preferences = UserPreference.where(:user => user, :preference => template.preference).first
    if preferences.email
        custom_template = NotificationTemplate.by_summary_and_classification(template.summary_key,
            Classification::EMAIL).first
        subject = custom_template.summary_key
        body = custom_template.body_key
        message = QuotrMailer.generate_message user, subject, body
        message.deliver_now
        @logger.info "Sent email for #{@class} to #{user.email}"
    end

    if preferences.internal
      custom_template = NotificationTemplate.by_summary_and_classification(template.summary_key,
            Classification::INTERNAL).first
      notification = Notification.new(:user => user, :notification_template => custom_template)
      notification.save
      @logger.info "Created notification for #{@class}"
    end
  end

  def self.enqueue(notification_template_id, user_id)
    validate_request notification_template_id, user_id
    params = create_params(notification_template_id, user_id)
    @logger.info "Creating #{@class} with params: #{params}"
    Resque.enqueue @class, params
  end
end
