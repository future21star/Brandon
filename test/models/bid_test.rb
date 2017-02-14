require 'test_helper'


class BidTest <  BaseModelTest
  def new
    return Bid.new
  end

  test "user expected to be set" do
    instance = new
    has_key(instance, :user)
    instance.user = User.first
    not_has_key instance, :user
  end

  test "purchase expected to be set" do
    instance = new
    has_key(instance, :purchase)
    instance.purchase = Purchase.first
    not_has_key instance, :purchase
  end

  test "purchase NOT expected to be set if free bid" do
    instance = new
    has_key(instance, :purchase)
    instance.category = Category.find_by_name(BID_CATEGORY_FREE)
    not_has_key instance, :purchase
  end

  test "top_up_history expected to be set if free bid" do
    instance = new
    has_key(instance, :top_up_history)
    instance.top_up_history = TopUpHistory.first
    not_has_key instance, :top_up_history
  end

  test "my_available should only return available bids" do
    user = create_cooked_business_user
    cases = 3
    purchase = create_cooked_purchase(user, packages(:three))
    save purchase
    pre_count = Bid.my_available(user).count
    assert_equal cases, pre_count
    bid = Bid.last
    bid.available = false
    save bid
    post_count = Bid.my_available(user).count
    assert_equal pre_count-1, post_count
  end

  test "purchase with required fields, should persist" do
    instance = new
    instance.user = User.first
    instance.purchase = Purchase.first
    instance.available = true
    instance.category = Category.find_by_name(BID_CATEGORY_FREE)
    instance.top_up_history = TopUpHistory.first
    unless instance.save
      fail "Failed to persist Bid. Errors: #{instance.errors.keys}"
    end
  end

  test "bids need to utilize optimistic locking" do
    history = create_cooked_top_up_history(Time.now)
    first = create_cooked_bid(history.user, nil, history)
    save first

    conflict = Bid.find_by_id(first.id)
    conflict.available = false
    save conflict

    assert first.available
    assert_nil first.consumed_at
    assert_raise(ActiveRecord::StaleObjectError) {
      first.available = false
      save first
    }

  end

  test "purchased bids should return AFTER free bids" do
    Bid.transaction do
      period_end = Time.now
      period_start = period_end-1
      user = create_cooked_user
      purchase = create_cooked_purchase(user, packages(:zero))
      top_up_history = create_cooked_top_up_history(period_start, period_end, user)
      bids = []
      types = [false, false, false, false, true, false, true, true, true]
      types.each { |free|
        if free
          bid = create_cooked_bid(user, nil, top_up_history)
          save bid
          bids << bid
        else
          bid = create_cooked_bid(user, purchase)
          save bid
          bids << bid
        end
      }
      number_of_free = types.select{|t| t}.size
      bids_size = Bid.where(:user => user).size
      assert_equal types.size, bids_size

      bids = Bid.my_available(user)
      assert_not_nil bids
      assert_equal bids_size, bids.size

      found_free = 0
      bids.each_index { |i|
        bid = bids[i]
        assert_not_nil bid
        if bid.free?
          found_free += 1
        end
        if i > number_of_free
          assert !bid.free?
        end
      }
      assert_equal number_of_free, found_free
      end
  end
end
