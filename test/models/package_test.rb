require 'test_helper'


class PackageTest < BaseModelTest
  def new
    return Package.new
  end

  test "name expected to be set" do
    instance = new
    has_key(instance, :name)
    instance.name = "name id"
    not_has_key instance, :name
  end

  test "quantity expected to be set" do
    instance = new
    has_key(instance, :quantity)
    instance.quantity = 1
    not_has_key instance, :quantity
  end

  test "price_per_unit expected to be set" do
    instance = new
    has_key(instance, :price_per_unit)
    instance.price_per_unit = 12.10
    not_has_key instance, :price_per_unit
  end

  test "total expected to be set" do
    instance = new
    has_key(instance, :total)
    instance.total = 12.10
    not_has_key instance, :total
  end

  test "quantity is only numeric, but allows decimals" do
    run_decimal_tests(:quantity);
  end

  # test "validate price_per_unit bounds" do
  #   test_cases = [0, 0.00, 99999999.99, -0.01, 100000000]
  #   expectations = [true, true, true, false, false]
  #   validate_bounds create_cooked_purchase, :price_per_unit, test_cases, expectations
  # end
  #
  # test "validate total bounds" do
  #   test_cases = [0, 0.00, 99999999.99, -0.01, 100000000]
  #   expectations = [true, true, true, false, false]
  #   validate_bounds create_cooked_purchase, :total, test_cases, expectations
  # end
end
