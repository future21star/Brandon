require 'test_helper'

class PromoCodeTest < BaseModelTest
  def new
    return PromoCode.new
  end

  test "start_date expected to be set" do
    instance = new
    has_key(instance, :start_date)
    instance.start_date = DateTime.now
    not_has_key instance, :start_date
  end

  test "category expected to be set" do
    instance = new
    has_key(instance, :category)
    instance.category =  Category.first
    not_has_key instance, :category
  end

  test "code expected to be set" do
    instance = new
    has_key(instance, :code)
    instance.code = "code id"
    not_has_key instance, :code
  end

  test "code expected to be in under max" do
    instance = new
    instance.code = "code id"
    not_has_key instance, :code
    instance.code = "This isa really long promo"
    has_key(instance, :code)
  end

  test "discount expected to be set" do
    instance = new
    has_key(instance, :discount)
    instance.discount = 10
    not_has_key instance, :discount
  end

  test "description expected to be set" do
    instance = new
    has_key(instance, :description)
    instance.description = "description of discount"
    not_has_key instance, :description
  end

  test "description expected to be under max" do
    instance = new
    instance.description = "description of discount"
    not_has_key instance, :description
    instance.description =  "This is a really long description that should faila"
    has_key(instance, :description)
  end

  test "discount is only numeric" do
      run_array_tests :discount, [1, 10, 100, "2"]
      run_array_tests :discount, [0, 101], false
  end

  test "discount must be within range" do
    instance = new
    instance.discount = 50
    not_has_key instance, :discount
    instance.discount = 0
    has_key instance, :discount
    instance.discount = 101
    has_key instance, :discount
  end

  test "start and end date should not be the same" do
    instance = new
    instance.start_date = DateTime.now
    instance.end_date = instance.start_date
    has_key instance, :date_match
    instance.end_date = (instance.end_date.to_time + 1.hours).to_datetime
    not_has_key instance, :date_match
  end

  test "happy path should save" do
    instance = create_cooked_promo_code
    save instance

    assert instance.errors.empty?
    assert_not_nil instance.id
  end

  test "Promo code within range should return expected" do
    code = "real code"
    now = Time.now.utc
    start_date = now - 1.day
    instance = create_cooked_promo_code(code, start_date, now)
    save instance

    assert instance.errors.empty?

    test_cases = [start_date, start_date + 1.minute, now]
    test_cases.each_index { |i|
      test_case = test_cases[i]
      found = PromoCode.is_promo_code_valid(code, PromoCode::SOURCE_REGISTRATION, test_case)
        assert_not_nil found, "Test case: #{i}"
    }
  end

  test "code should be upper case" do
    instance = new
    expected = "TEST"
    test_cases = ["Test", "TEST", expected.downcase]
    test_cases.each { |test_case|
      instance.code = test_case
      instance.clean_input!
      assert_equal expected, instance.code, "Test case: #{test_case}"
    }
  end

  test "Promo code outside range should return expected" do
    code = "real code"
    now = Time.now.utc
    start_date = now - 1.day
    instance = create_cooked_promo_code(code, start_date, now)
    save instance

    assert instance.errors.empty?

    test_cases = [start_date - 1.second, start_date - 1.minute, now + 1.second, now + 1.minute]
    test_cases.each_index { |i|
      test_case = test_cases[i]
      assert_raises(ActiveRecord::RecordNotFound) {
        PromoCode.is_promo_code_valid(code, PromoCode::SOURCE_REGISTRATION, test_case)
      }
    }
  end

  test "promo code as percent should return decimal value" do
    instance = new
    instance.discount = 10

    percent = instance.discount_as_percent
    assert_not_nil percent
    assert_equal 0.1, percent
  end

  test "apply promo code against a value should returna discounted amount" do
    total = 12.99
    instance = new
    instance.discount = 20

    discounted_value = instance.discount_price(total)
    assert_not_nil discounted_value
    assert_equal 10.39, discounted_value
  end
end
