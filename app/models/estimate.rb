class Estimate < BaseModel
  has_paper_trail

  validates_presence_of :summary, :description, :price, :duration, :quantifier, :quote
  validates_length_of :summary,  minimum: 5, maximum: 150
  validates_length_of :description,  minimum: 10
  validates_associated :quote
  validates_numericality_of :price, :duration
  validates_numericality_of :price, :less_than_or_equal_to => 99999999.99, :greater_than_or_equal_to => 0
  validates_numericality_of :duration, :less_than_or_equal_to => 999999.99, :greater_than_or_equal_to => 0

  belongs_to :quote, :autosave => true
  belongs_to :quantifier
end
