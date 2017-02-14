
class SeedableQuantifier < Quantifier
  def readonly?
    false
  end
end

category_time = Category.find_by_name(QUANTIFIER_CATEGORY_TIME)
category_distance = Category.find_by_name(QUANTIFIER_CATEGORY_DISTANCE)
category_measurement = Category.find_by_name(QUANTIFIER_CATEGORY_MEASUREMENT)

SeedableQuantifier.create ([
    {quantifier: "Hours", category: category_time},
    {quantifier: "Days", category: category_time},
    {quantifier: "Weeks", category: category_time},

    {quantifier: "Inches", category: category_distance},
    {quantifier: "Feet", category: category_distance},
    {quantifier: "Meters", category: category_distance},

    {quantifier: "Width", category: category_measurement},
    {quantifier: "Length", category: category_measurement},
    {quantifier: "Height", category: category_measurement},

])
