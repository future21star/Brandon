require 'test_helper'


class PurchaseTest < BaseModelTest
  def new
    return Purchase.new
  end

  test "transaction_id expected to be set" do
    instance = new
    has_key(instance, :transaction_id)
    instance.transaction_id = "transaction id"
    not_has_key instance, :transaction_id
  end

  test "user expected to be set" do
    instance = new
    has_key(instance, :user)
    instance.user = User.new
    not_has_key instance, :user
  end

  test "package expected to be set" do
    instance = new
    has_key(instance, :package)
    instance.package = Package.first
    not_has_key instance, :package
  end

  test "brand expected to be set" do
    instance = new
    has_key(instance, :package)
    instance.package = Package.first
    not_has_key instance, :package
  end

  test "last_4 expected to be set" do
    instance = new
    has_key(instance, :last_4)
    instance.last_4 = 1232
    not_has_key instance, :last_4
  end

  test "exp_month expected to be set" do
    instance = new
    has_key(instance, :exp_month)
    instance.exp_month = 2
    not_has_key instance, :exp_month
  end

  test "exp_year expected to be set" do
    instance = new
    has_key(instance, :exp_year)
    instance.exp_year = 2020
    not_has_key instance, :exp_year
  end

  test "total expected to be set" do
    instance = new
    has_key(instance, :total)
    instance.total = 2020.32
    not_has_key instance, :total
  end

  test "discount expected to be set if promo_code set" do
    instance = new
    not_has_key(instance, :discount)
    instance.promo_code = PromoCode.first
    has_key(instance, :discount)
    instance.discount = 21.32
    not_has_key instance, :discount
  end

  test "Purchase submit with proper fields should persist" do
    purchase = create_cooked_purchase

    unless purchase.save
      fail "failed to save...errors: #{purchase.errors.keys}"
    end

    assert purchase.id
    assert_equal 10 * 0.25, 2.50
    assert_equal 10, purchase.bids.count
  end

  test "summary scope should return only the latest" do
    expected = 5
    user = create_cooked_business_user
    save user
    (expected+1).times.each{
      save create_cooked_purchase(user)
    }

    results = Purchase.summary(user)
    assert_not_nil results
    assert_same expected, results.length
  end
end
