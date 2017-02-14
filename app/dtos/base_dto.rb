class BaseDTO
  def self.instances_to_array_of_hashes(objects)
    dtos = []
    objects.each { |obj| dtos << instance_to_hash(obj) }
    return dtos
  end
end