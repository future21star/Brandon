require 'test_helper'

class PurchaseDTOTest < BaseModelTest
  test "Create DTO from instance should be as expected" do
    instance = create_cooked_purchase
    save instance

    dto = PurchaseDTO.instance_to_hash(instance)
    assert_not_nil dto
    assert_not_nil dto[:id]
    assert_equal instance.id, dto[:id]
    assert_not_nil dto[:quantity]
    assert_equal instance.package.quantity, dto[:quantity]
    assert_not_nil dto[:total]
    assert_equal instance.total, dto[:total]
    assert_not_nil dto[:transaction]
    assert_equal instance.transaction_id, dto[:transaction]
    assert_not_nil dto[:date]
    assert_equal instance.created_at, dto[:date]

  end
end
