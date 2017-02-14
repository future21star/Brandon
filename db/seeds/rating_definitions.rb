
class SeedableRatingDefinition < RatingDefinition
  def readonly?
    false
  end
end


SeedableRatingDefinition.create([
               {:category => Category.find_by_name(RATING_CATEGORY_GENERAL), :brackets => '1|2|3|4|5|6|7|8|9|10'},
           ])
