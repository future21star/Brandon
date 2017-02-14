require 'test_helper'

class TagTest < BaseModelTest
  def new
    return Tag.new
  end

  test "When tag saved should be lower case" do
    skip
    test_cases = ["TEST", "taG", "taggy", "OneMore"]
    for test_case in test_cases
      tag = new
      tag.name = test_case
      tag.save
      tag = Tag.find_by_id tag.id
      assert tag
      assert_equal test_case.downcase, tag.name
    end
  end

  test "Like query should return similar tags" do
    skip
    tags = ["aabda", "Test", "tester", "est", "tes"]
    tags.each { |name|
      tag = Tag.create :name => name
      assert tag.id
    }

    results = Tag.like "est"
    assert results
    assert_equal 3, results.count
    assert_equal tags[1].downcase, results[0].name
    assert_equal tags[2], results[1].name
    assert_equal tags[3], results[2].name
  end

  test "instance should be read only, no update" do
    instance = Tag.first
    instance.name = "no"
    assert_raise do ReadOnlyRecord
    instance.save!
    end
  end

  test "instance should be read only, no save" do
    instance = Tag.new(:name => 'no')
    assert_raise do ReadOnlyRecord
    instance.save!
    end
  end
end
