class NotificationTemplate < BaseModel

  scope :by_summary_and_classification, ->(summary_key, classification) {where(:summary_key => summary_key,
                                                                     :classification => classification)}

  validates_presence_of :summary_key, :body_key, :classification, :preference

  belongs_to :preference
end
