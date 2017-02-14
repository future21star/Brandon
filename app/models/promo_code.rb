class PromoCode < BaseModel
  has_paper_trail

  SOURCE_REGISTRATION='registration'
  SOURCE_PURCHASING='purchasin'

  scope :between, lambda {|start_date, end_date|
    where("start_date <= ? AND end_date >= ?", start_date.change(:usec => 0), end_date.change(:usec => 0) )
  }

  before_validation :clean_input!

  validates_presence_of :start_date, :category, :code, :discount, :description
  validates_numericality_of :discount, :less_than_or_equal_to => 100, :greater_than => 0
  validates_length_of :code, :maximum => 25
  validates_length_of :description, :maximum => 50
  validate :validate_dates_do_not_match

  has_many :promo_code_associations
  belongs_to :category

  def clean_input!
    self.code = self.code ? self.code.upcase : self.code
  end

  def validate_dates_do_not_match
    if start_date && end_date
      format = "%Y%m%dT%H%M"
      if start_date.strftime(format).eql? end_date.strftime(format)
        errors.add :date_match, "Start Date and End Date must not be the same"
      end
    end
  end

  def discount_as_percent
    return self.discount.to_f / 100
  end

  def discount_price(amount)
    return (amount - (amount * discount_as_percent).round(2))
  end

  def self.is_promo_code_valid(code, source, date=Time.now.utc)
    if source.downcase == SOURCE_REGISTRATION
      category = Category.find_by_name(PROMO_CODE_REGISTRATION)
    else
      category = Category.find_by_name(PROMO_CODE_PURCHASE)
    end
    code = code.upcase

    promo_code = PromoCode.between(date, date).where(:code => code, :category => category).first
    unless promo_code
      raise ActiveRecord::RecordNotFound.new("Invalid promo code")
    end
    return promo_code
  end
end
