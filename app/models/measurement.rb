class Measurement < BaseModel
  has_paper_trail

  validates_presence_of :value, :unit_quantifier, :classification_quantifier
  validates_numericality_of :value, :less_than_or_equal_to => 999999.99, :greater_than_or_equal_to => 0

  belongs_to :unit_quantifier, :class_name => Quantifier
  belongs_to :classification_quantifier, :class_name => Quantifier
  belongs_to :measurement_group

end
