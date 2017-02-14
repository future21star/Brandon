class Quote < BaseModel
  has_paper_trail

  # weird bug where the order was not by the id so forcing it.
  scope :mine, ->(user, page=1) {where(:business => user.business).order(:id).paginate(page: page)}
  scope :summary, ->(user) {mine(user).limit(5)}

  validates_presence_of :business, :project
  validates_associated :bid
  validate :validate_bid!, :validate_project_state

  belongs_to :business
  belongs_to :project
  belongs_to :bid, :autosave => true
  has_many :estimates, inverse_of: :quote

  private
    def validate_bid!
      # WHY IS THIS CALLED TWICE!?!?!?!?!?!?
      if errors.blank? && !bid
        bid = Bid.my_available(business.user).take
        unless bid
          errors.add :bid, "is not available for use"
          return
        end
        bid.available = false
        bid.consumed_at = Time.now.utc
        self.bid = bid
      end
    end

  def validate_project_state
    if project
      unless project.published?
        errors.add :project, "Project is not open for quotes"
        return
      end
    end
  end
end
