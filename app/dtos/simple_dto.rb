class SimpleDTO < BaseDTO
  def self.instance_to_hash(obj)
    dto = {}
    obj.attributes.each do |attr_name, attr_value|
      unless attr_name == :created_at || attr_name == :updated_at
        dto[attr_name] = attr_value
      end
    end
    return dto
  end
end