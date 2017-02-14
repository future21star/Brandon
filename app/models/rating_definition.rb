class RatingDefinition < BaseModel

  validates_presence_of :category, :brackets

  belongs_to :category

  def readonly?
    true
  end

  def get_values
    ratings = []
    split = brackets.split '|'
    split.each { |rating|
      ratings << rating.to_i
    }
    return ratings
  end

  def supports_rating?(value)
    return value != nil && get_values.include?(value)
  end
end
