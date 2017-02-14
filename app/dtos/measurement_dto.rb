class MeasurementDTO < BaseDTO
  def self.instance_to_hash(measurement)
    return {
        id: measurement.id,
        value: measurement.value,
        unit_quantifier_id: measurement.unit_quantifier_id,
        classification_quantifier_id: measurement. classification_quantifier_id
    }
  end
end