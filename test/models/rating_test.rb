require 'test_helper'

class RatingTest < BaseModelTest
  def new
    return Rating.new
  end

  test "user expected to be set" do
    instance = new
    has_key(instance, :user)
    instance.user = User.first
    not_has_key instance, :user
  end

  test "business expected to be set" do
    instance = new
    has_key(instance, :business)
    instance.business = Business.first
    not_has_key instance, :business
  end

  test "rating_definition expected to be set" do
    instance = new
    has_key(instance, :rating_definition)
    instance.rating_definition = RatingDefinition.first
    not_has_key instance, :rating_definition
  end

  test "rating expected to be set" do
    instance = new
    has_key(instance, :rating)
    instance.rating = 100
    not_has_key instance, :rating
  end

  test "comments expected to be set" do
    instance = new
    has_key(instance, :comments)
    instance.comments = "We are a rating comment"
    not_has_key instance, :comments
  end

  test "validate_rating_in_bracket must be within definition" do
    instance = new
    instance.rating_definition = RatingDefinition.first
    test_cases = [0.1,11,0,1..10]
    expected = [false, false, false]
    10.times {expected << true }

    test_cases.each_index { |i |
      test_case = test_cases[i]
      instance.rating = test_case
      instance.validate_rating_in_bracket

      puts "Test case #{test_case}...expected: #{expected[i]}"
      if !expected[i]
        not_has_key instance, :rating
      else
        has_key instance, :rating
      end
    }

  end

  test "Happy path should persist" do
    instance = create_cooked_rating
    save instance

    assert_equal true, instance.errors.empty?
    assert instance.id
    assert_not_nil instance.comments
    assert_not_nil instance.rating
    assert_not_nil instance.business
    assert_not_nil instance.business.id
    assert_not_nil instance.user
    assert_not_nil instance.user.id
    assert_not_nil instance.rating_definition
    assert_not_nil instance.rating_definition.id
  end

  test "general ratings should return ratings" do
    rating = create_cooked_rating
    save rating

    assert_equal true, rating.errors.empty?

    results = Rating.business_general_ratings(rating.business.id, 1)
    assert_not_nil results
    result = results[0]
    assert_not_nil result
    assert_equal rating.id, result.id
    assert_equal rating.rating_definition.id, result.rating_definition.id
  end
end