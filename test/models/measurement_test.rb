require 'test_helper'

class MeasurementTest < BaseModelTest
  def new
    return Measurement.new
  end

  test "value expected to be set" do
    instance = new
    has_key(instance, :value)
    instance.value = 1.23
    not_has_key instance, :value
  end

  test "value is only numeric, but allows decimals" do
    run_decimal_tests(:value);
  end

  test "validate value bounds" do
    test_cases = [0, 0.00, 999999.99, -0.01, 1000000]
    expectations = [true, true, true, false, false]
    instance = create_cooked_measurement
    validate_bounds instance, :value, test_cases, expectations, method(:randomize)
  end

  def randomize(instance)
    instance.measurement_group.name = SecureRandom.urlsafe_base64(25)
    return instance
  end

  test "classification_quantifier expected to be set" do
    instance = new
    has_key(instance, :classification_quantifier)
    instance.classification_quantifier = Quantifier.first
    not_has_key instance, :classification_quantifier
  end

  test "unit_quantifier expected to be set" do
    instance = new
    has_key(instance, :unit_quantifier)
    instance.unit_quantifier = Quantifier.first
    not_has_key instance, :unit_quantifier
  end

  test "When submitting a value, the whole structure should be created" do
    instance = create_cooked_measurement
    save instance

    assert_equal true, instance.errors.empty?
    assert instance.id
    assert instance.value
    assert instance.measurement_group
    assert_equal 1.4, instance.value
    assert instance.classification_quantifier
    assert instance.classification_quantifier.id
    assert instance.unit_quantifier
    assert instance.unit_quantifier.id
  end

end
