# This class is largely used for converting server objects into react BasicSelect objects
module KeyValueHelper
  @logger = MyLogger.factory(self)

  def self.create_from_quantifiers(quantifiers)
    key_values = []
    quantifiers.each { |quantifier|
      key_values << {id: quantifier.id, name: quantifier.quantifier}
    }
    return key_values
  end
end
