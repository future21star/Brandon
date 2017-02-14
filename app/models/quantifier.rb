class Quantifier < BaseModel

  scope :by_category, ->(category) {where(category: Category.find_by_name(category))}

  validates_presence_of :quantifier, :category
  validates_length_of :quantifier, maximum: 50

  belongs_to :category

  def readonly?
    true
  end
end
