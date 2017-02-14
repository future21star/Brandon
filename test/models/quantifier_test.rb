require 'test_helper'

class QuantifierTest < BaseModelTest
  def new
    return Quantifier.new
  end

  test "quantifier expected to be set" do
    instance = new
    has_key(instance, :quantifier)
    instance.quantifier = "Cookies"
    not_has_key instance, :quantifier
  end

  test "category expected to be set" do
    instance = new
    has_key(instance, :category)
    instance.category = Category.first
    not_has_key instance, :category
  end

  test "instance should be read only, no update" do
    instance = Quantifier.first
    instance.quantifier = "no"
    assert_raise do ReadOnlyRecord
    instance.save!
    end
  end

  test "instance should be read only, no save" do
    instance = Quantifier.new(:quantifier => 'no')
    assert_raise do ReadOnlyRecord
    instance.save!
    end
  end

  test "by_category should return list of categories" do
    category = categories(:time).name
    assert_not_nil category

    results = Quantifier.by_category(category)
    assert_not_nil results
    assert 2 <= results.size
    assert_equal "Hours", results[0].quantifier
    assert_equal "Week", results[1].quantifier
    assert_equal "Day", results[2].quantifier
  end
end
