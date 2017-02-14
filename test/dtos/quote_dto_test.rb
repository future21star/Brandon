require 'test_helper'

class QuoteDTOTest < BaseModelTest
  test "Create DTO from instance should be as expected" do
    instance = create_cooked_quote
    save instance

    dto = QuoteDTO.instance_to_hash(instance)
    assert_not_nil dto
    assert_not_nil dto[:id]
    assert_equal instance.id, dto[:id]
    assert_not_nil dto[:project]
    assert_equal instance.project.title, dto[:project]
    assert_not_nil dto[:type]
    assert_equal instance.bid.category.name, dto[:type]
    assert_not_nil dto[:date]
    assert_equal instance.created_at, dto[:date]

  end
end
