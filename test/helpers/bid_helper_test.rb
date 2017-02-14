require 'test_helper'

class BidHelperTest < ActionController::TestCase

  test "get_users_available_for_top_up should only return accounts with consumed bids in window" do
    period_start = Time.now.utc
    period_end = period_start + 1
    dates = [period_start, period_end, period_end + 1]
    user = create_cooked_user
    history = create_cooked_top_up_history(period_start, period_end, user)
    dates.each_index { |i|
      save(create_cooked_bid(user, nil, history, dates[i]))
    }

    results = BidHelper.get_users_available_for_top_up(period_start, period_end)
    assert_not_nil results
    assert_equal user.id, results[0][:user_id]
    assert_equal 2, results[0][:count]
  end

  test "get_users_available_for_top_up should raise if non-time entered for start_date" do
    exception = assert_raise(ArgumentError) {
      BidHelper.get_users_available_for_top_up(Time.now.utc.to_s, Time.now.utc)
    }
    assert exception
    assert exception.message.downcase.include?("start_date")
  end

  test "get_users_available_for_top_up should raise if non-time entered for end_date" do
    exception = assert_raise(ArgumentError) {
      BidHelper.get_users_available_for_top_up(Time.now.utc, Time.now.utc.to_s)
    }
    assert exception
    assert exception.message.downcase.include?("end_date")
  end

  def multi_user_setup(dates, user, user2)
    period_end = Time.now
    period_start = period_end-1
    history = create_cooked_top_up_history(period_start, period_end, user)
    history2 = create_cooked_top_up_history(period_start, period_end, user2)
    dates.each_index { |i|
      save(create_cooked_bid(user, nil, history, dates[i]))
      if i == 0
        save(create_cooked_bid(user2, nil, history2, dates[i]))
      elsif i == 1
        # VET that non-free bids are not included
        save(create_cooked_bid(user2, create_cooked_purchase(user2), nil, dates[i]))
      end
    }
  end

  test "get_users_available_for_top_up should only return accounts with used, free bids" do
    start_date = Time.now.utc
    end_date = start_date + 1
    dates = [start_date, end_date, end_date + 1]
    user = create_cooked_user
    user2 = create_cooked_user
    multi_user_setup dates, user, user2

    results = BidHelper.get_users_available_for_top_up(start_date, end_date)
    assert_not_nil results
    assert_equal user.id, results[0][:user_id]
    assert_equal 2, results[0][:count]
    assert_equal user2.id, results[1][:user_id]
    assert_equal 1, results[1][:count]
  end

  test "create_top_up_history_for_accounts should create_histories" do
    start_date = Time.now.utc
    end_date = start_date + 1
    dates = [start_date, end_date, end_date + 1]
    user = create_cooked_user
    user2 = create_cooked_user
    multi_user_setup dates, user, user2

    accounts = BidHelper.get_users_available_for_top_up(start_date, end_date)
    assert_not_nil accounts
    histories = BidHelper.create_top_up_history_for_accounts(start_date, end_date, accounts)
    assert_not_nil histories
    assert_equal 2, histories.size
    assert_not_nil histories[0]
    assert_equal user, histories[0].user
    assert_equal 2, histories[0].owed
    assert_equal nil, histories[0].completed_at
    assert_not_nil histories[1]
    assert_equal user2, histories[1].user
    assert_equal 1, histories[1].owed
    assert_equal nil, histories[1].completed_at
  end

  test "re-running the same period should gracefully handle duplicates" do
    start_date = Time.now.utc
    end_date = start_date + 1
    dates = [start_date, end_date, end_date + 1]
    user = create_cooked_user
    user2 = create_cooked_user
    multi_user_setup dates, user, user2

    # simulate the rake task already ran once but only processed the first user
    simulated = create_cooked_top_up_history(start_date, end_date, user)
    save simulated

    accounts = BidHelper.get_users_available_for_top_up(start_date, end_date)
    assert_not_nil accounts
    assert_equal 2, accounts.size
    histories = BidHelper.create_top_up_history_for_accounts(start_date, end_date, accounts)
    assert_not_nil histories
    assert_equal 1, histories.size
    assert_not_nil histories[0]
    assert_equal user2, histories[0].user
    assert_equal 1, histories[0].owed
    assert_equal nil, histories[0].completed_at
  end
end
