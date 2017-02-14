require 'test_helper'

class CategoryTest < BaseModelTest
  def new
    return Category.new
  end

  test "name expected to be set" do
    instance = new
    has_key(instance, :name)
    instance.name = "Dope"
    not_has_key instance, :name
  end

  test "validate name bounds enforced" do
    skip
    test_cases = ["s", create_string(50), create_string(51)]
    expectations = [true, true, false]
    instance = new
    validate_bounds instance, :name, test_cases, expectations
  end
  
  test "instance should be read only, no update" do
    instance = Category.first
    instance.name = "no"
    assert_raise do ReadOnlyRecord
    instance.save!
    end
  end

  test "instance should be read only, no save" do
    instance = Category.new(:name => 'no')
    assert_raise do ReadOnlyRecord
    instance.save!
    end
  end
end
