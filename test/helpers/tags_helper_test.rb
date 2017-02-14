require 'test_helper'

class TagsHelperTest < ActionController::TestCase
  test "find tags like name should return expected" do
    tags = TagsHelper.find_tag_like_name 'en'
    assert tags
    assert_equal 2, tags.count

    tags = TagsHelper.find_tag_like_name 'eno'
    assert tags
    assert_equal 1, tags.count
    assert_equal 'Reno', tags[0].name
  end
end
