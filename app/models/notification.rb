class Notification < BaseModel

  scope :mine, ->(user) {where(:user => user)}

  validates_presence_of :user, :notification_template

  belongs_to :user
  belongs_to :notification_template
end
