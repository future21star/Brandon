require 'test_helper'

class BusinessTagTest < ActiveSupport::TestCase
  test "tag and business expected to be set" do
    business_tag = BusinessTag.new
    assert_not_same true, business_tag.valid?
    assert_equal [:business, :tag], business_tag.errors.keys
    business_tag.tag = Tag.new
    assert_not_same true, business_tag.valid?
    assert_equal [:business], business_tag.errors.keys
    business_tag.business = Business.new
    assert_same true, business_tag.valid?
  end
end
