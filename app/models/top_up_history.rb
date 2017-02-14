class TopUpHistory < BaseModel

  validates_presence_of :user, :owed, :period_start, :period_end
  validates_numericality_of :owed, :greater_than => 0

  belongs_to :user
  belongs_to :promo_code
end
