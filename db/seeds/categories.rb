class SeedableCategory < Category
  def readonly?
    false
  end
end

SeedableCategory.create([
               {name: QUANTIFIER_CATEGORY_TIME},
               {name: QUANTIFIER_CATEGORY_DISTANCE},
               {name: QUANTIFIER_CATEGORY_MEASUREMENT},
               {name: BID_CATEGORY_FREE},
               {name: BID_CATEGORY_PAID},
               {name: PROMO_CODE_PURCHASE},
               {name: PROMO_CODE_REGISTRATION},
               {name: RATING_CATEGORY_GENERAL}
           ])
