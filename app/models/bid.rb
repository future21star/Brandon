class Bid < BaseModel
  has_paper_trail

  scope :my_available, ->(user) {where(:user => user, :available => true).order(category_id: :asc)}

  validates_presence_of :category, :user
  validates_presence_of :purchase, :unless => :free?
  validates_presence_of :top_up_history, :unless => :paid?
  validates_associated :purchase

  belongs_to :user
  belongs_to :purchase
  belongs_to :top_up_history
  belongs_to :category
  has_one :quote, inverse_of: :bid

  def free?
    # compare against the category_id, using the self.category object causes an eager load of the object
    return Category.find_by_name(BID_CATEGORY_FREE).id === self.category_id
  end

  # FIXME: We should be able to invert the free check in the validate_presence_of definition but it wasn't working
  def paid?
    # compare against the category_id, using the self.category object causes an eager load of the object
    return Category.find_by_name(BID_CATEGORY_PAID).id === self.category_id
  end
end
