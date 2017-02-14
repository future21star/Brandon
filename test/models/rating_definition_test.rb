require 'test_helper'

class RatingDefinitionTest < BaseModelTest
  def new
    return RatingDefinition.new
  end

  test "brackets expected to be set" do
    instance = new
    has_key(instance, :brackets)
    instance.brackets = '1|23|5'
    not_has_key instance, :brackets
  end

  test "category expected to be set" do
    instance = new
    has_key(instance, :category)
    instance.category = Category.first
    not_has_key instance, :category
  end

  test "get brackets should return expected array" do
    instance = RatingDefinition.first
    assert_not_nil instance

    expected = Array 1..10

    results = instance.get_values
    assert_not_nil results
    expected.each_index { |i|
      assert_equal expected[i], results[i]
    }
  end

  test "does definition support rating should return true if it does" do
    instance = RatingDefinition.first
    assert_not_nil instance


    Array(1..10).each { |i|
      assert instance.supports_rating?(i), "test case #{i} failed"
    }
  end

  test "does definition support rating should return false if it does not" do
    instance = RatingDefinition.first
    assert_not_nil instance

    check=[0, Array(11..19)]

    check.each { |i|
      assert !instance.supports_rating?(i), "test case #{i} failed"
    }
  end
end