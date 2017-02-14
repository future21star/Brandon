class RatingDTO < BaseDTO
  def self.instance_to_hash(rating)
    return {
      :id => rating.id,
      :rating => rating.rating,
      :comments => rating.comments
    }
  end
end