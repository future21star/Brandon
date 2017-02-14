require 'test_helper'


class TopUpHistoryTest <  BaseModelTest
  def new
    return TopUpHistory.new
  end

  test "user expected to be set" do
    instance = new
    has_key(instance, :user)
    instance.user = User.first
    not_has_key instance, :user
  end

  test "owed expected to be set" do
    instance = new
    has_key(instance, :owed)
    instance.owed = 2
    not_has_key instance, :owed
  end

  test "period_start expected to be set" do
    instance = new
    has_key(instance, :period_start)
    instance.period_start = Time.new
    not_has_key instance, :period_start
  end

  test "period_end expected to be set" do
    instance = new
    has_key(instance, :period_end)
    instance.period_end = Time.new
    not_has_key instance, :period_end
  end

  test "validate value bounds" do
    period_end = Time.now
    period_start = period_end-1
    test_cases = [0, 1, 2, 3]
    expectations = [false, true, true, true]
    validate_bounds create_cooked_top_up_history(period_start, period_start), :owed, test_cases, expectations
  end

  test "When submitting a top_up_history, the whole structure should be created" do
    period_end = Time.now
    period_start = period_end-1
    instance = create_cooked_top_up_history(period_start, period_end)
    save instance

    assert_equal true, instance.errors.empty?
    assert instance.id
    assert instance.user
    assert instance.user.id
    assert instance.owed
  end
end
