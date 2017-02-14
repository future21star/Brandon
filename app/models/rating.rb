class Rating < BaseModel
  has_paper_trail

  scope :business_general_ratings, ->(business_id, page=1) {
    where(:business_id => business_id,
          :rating_definition => RatingDefinition.find_by_category_id(Category.find_by_name(RATING_CATEGORY_GENERAL).id)
    ).paginate(:page => page)
  }

  validates_presence_of :business, :user, :rating, :comments, :rating_definition
  validate :validate_rating_in_bracket

  belongs_to :business
  belongs_to :user
  belongs_to :rating_definition


  def validate_rating_in_bracket
    if @rating

      unless @rating_definition.supports_rating?(@rating)
        errors.add self, "Rating is not supported by the rating definitions values"
        return
      end
    end
  end
end
