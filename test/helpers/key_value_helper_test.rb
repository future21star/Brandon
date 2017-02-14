require 'test_helper'

class KeyValueHelperTest < ActionController::TestCase

  test "create_from_quantifiers should return proper key_value_pairs" do
    category = categories(:measurement).name
    assert_not_nil category

    quantifiers = Quantifier.by_category(category)
    assert_not_nil quantifiers

    array_of_hashes = KeyValueHelper.create_from_quantifiers(quantifiers)
    assert_not_nil array_of_hashes

    array_of_hashes.each_index { |i|
      hash = array_of_hashes[i]
      assert_not_nil hash
      assert_equal quantifiers[i].id, hash[:id]
      assert_equal quantifiers[i].quantifier, hash[:name]
    }
  end
end
