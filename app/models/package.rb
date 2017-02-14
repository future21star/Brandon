class Package < ActiveRecord::Base

  validates_presence_of :name, :quantity, :price_per_unit, :total
  validates_numericality_of :quantity
  validates_numericality_of :price_per_unit, :total, :less_than_or_equal_to => 99999999.99, :greater_than_or_equal_to => 0

  default_scope { where(:inactivated_at => nil)}

  def readonly?
    true
  end
end
