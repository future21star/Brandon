require 'test_helper'



class EstimateTest  <  BaseModelTest

  def new
    return Estimate.new
  end

  test "summary expected to be set" do
    instance = new
    has_key(instance, :summary)
    instance.summary = "This is an example summary"
    not_has_key instance, :summary
  end

  test "description expected to be set" do
    instance = new
    has_key(instance, :description)
    instance.description = "test description that needs to be so long that it doesn't trigger the other validations"
    not_has_key instance, :description
  end

  test "price expected to be set" do
    instance = new
    has_key(instance, :price)
    instance.price = 1
    not_has_key instance, :price
  end

  test "duration expected to be set" do
    instance = new
    has_key(instance, :duration)
    instance.duration = 1
    not_has_key instance, :duration
  end

  test "price is only numeric, but allows decimals" do
    run_decimal_tests(:price);
  end

  test "duration is only numeric, but allows decimals" do
    run_decimal_tests(:duration);
  end

  test "quantifier expected to be set" do
    instance = new
    has_key(instance, :quantifier)
    instance.quantifier = Quantifier.first
    not_has_key instance, :quantifier
  end

  test "validate summary bounds enforced" do
    test_cases = ["12345", create_string(150), "a234", create_string(151)]
    expectations = [true, true, false, false]
    quote = create_cooked_quote
    save quote
    validate_bounds quote.estimates[0], :summary, test_cases, expectations
  end

  test "validate price bounds" do
    test_cases = [0, 0.00, 99999999.99, -0.01, 100000000]
    expectations = [true, true, true, false, false]
    quote = create_cooked_quote
    save quote
    validate_bounds quote.estimates[0], :price, test_cases, expectations
  end

  test "validate duration bounds" do
    test_cases = [0, 0.00, 999999.99, -0.01, 1000000]
    expectations = [true, true, true, false, false]
    quote = create_cooked_quote
    save quote
    validate_bounds quote.estimates[0], :duration, test_cases, expectations
  end

  test "When submitting a estimate, data structure should be created" do
    Quote.transaction do
      quote = create_cooked_quote
      summary = "This is am estimates summary"
      description = "test description that needs to be so long that it doesn't trigger the other validations"
      estimate1 = Estimate.new(:summary => summary + "1", :description => description + "1", :price => 1.21,
                               :duration => 11.5, :quantifier => Quantifier.first)
      quote.estimates.clear
      quote.estimates << estimate1

      used_bid_count = Bid.my_available(quote.business.user).count
      save(estimate1)

      assert_equal true, quote.errors.empty?
      assert quote.id
      assert quote.bid.id
      assert_equal false, quote.bid.available
      post_save_used_bid_count = Bid.my_available(quote.business.user).count
      assert_equal used_bid_count-1, post_save_used_bid_count
      assert quote.estimates
      assert quote.estimates[0].id
      assert_equal  estimate1.summary, quote.estimates[0].summary
      assert_equal  estimate1.description, quote.estimates[0].description
      assert_equal  estimate1.price, quote.estimates[0].price
      assert_equal  estimate1.duration, quote.estimates[0].duration
      assert_equal  estimate1.quantifier, quote.estimates[0].quantifier
    end
  end
end
