class RatingsDTO < BaseDTO
  attr_reader :category, :ratings

  def initialize(category, ratings)
    @category = category
    @ratings = ratings
  end

  def self.create_from_array(ratings)
    ratingDTOs = []
    ratings.each { |rating|
      ratingDTOs << RatingDTO.instance_to_hash(rating)
    }
      return RatingsDTO.new(Category.find_by_name(RATING_CATEGORY_GENERAL).id, ratingDTOs)
  end

  def self.instance_to_hash(ratings)
    ratingDTOs = []
    ratings.each { |rating|
      ratingDTOs << RatingDTO.instance_to_hash(rating)
    }
    return {
        :category => Category.find_by_name(RATING_CATEGORY_GENERAL).id,
        :ratings => ratingDTOs
    }
  end
end