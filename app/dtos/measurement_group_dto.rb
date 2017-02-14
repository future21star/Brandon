class MeasurementGroupDTO < BaseDTO

  def self.instance_to_hash(measurement_group)
    groups = []
    measurement_group.measurements.each { |x|
      groups << (MeasurementDTO.instance_to_hash(x))
    }
    return {
      :id => measurement_group.id,
      :name => measurement_group.name,
      :order => measurement_group.order,
      :group_id => measurement_group.group_id,
      :measurements_attributes => groups
    }
  end
end