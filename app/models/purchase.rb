class Purchase < BaseModel
  has_paper_trail

  scope :mine, ->(user, page=1) {where(:user => user).order(:id).paginate(page: page)}
  scope :summary, ->(user) {mine(user).limit(5)}

  validates_presence_of :transaction_id, :user, :package, :brand, :last_4, :exp_month, :exp_year, :total
  validates_presence_of :discount, :if => :promo_code

  after_create :create_bids
  belongs_to :user
  belongs_to :package
  belongs_to :promo_code
  belongs_to :promo_code_association
  has_many :bids

  def create_bids
    BidHelper.create_bids(package.quantity, self, nil)
  end
end
