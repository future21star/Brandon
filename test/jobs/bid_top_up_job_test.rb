require 'test_helper'

class BidTopUpJobTests < BaseModelTest

  def new
    return BidTopUpJob.new
  end

  def params(id=TopUpHistory.first.id)
    return [{"top_up_history_id" => id}]
  end

  test "top_up_history_id_is_required_to create job" do
    test_cases = [nil, {}]
    test_cases.each { |test_case|
      exception = assert_raise(ArgumentError) {
        BidTopUpJob.enqueue test_case
      }
      assert exception
      assert exception.message.downcase.include?("missing required parameter {top_up_history_id}"),
             "Test case: #{test_cases}. e: #{exception}"
    }
  end

  test "top_up_history_id_is_required on perform" do
    test_cases = [[{}]]
    test_cases.each { |test_case|
      exception = assert_raise(ArgumentError) {
        BidTopUpJob.perform test_case
      }
      assert exception
      assert exception.message.downcase.include?("missing required parameter {top_up_history_id}"),
             "Test case: #{test_cases}. e: #{exception}"
    }
  end

  test "finding_a top_up_history is required on perform" do
      exception = assert_raise(ActiveRecord::RecordNotFound) {
        BidTopUpJob.perform params(-1)
    }
  end

  test "running a job that has previously run successfully should return only true" do
    top_up = create_cooked_top_up_history Time.now.utc - 5
    top_up.completed_at = Time.now.utc
    save top_up

    assert BidTopUpJob.perform params(top_up.id)
  end

  test "enqueuing_jobs should succeed" do
    Resque.instance_eval do
      def enqueue(klass, *args)
        return true
      end
    end
    assert BidTopUpJob.enqueue(1)
  end

  test "happy_path_should_add_bids_and_close_history" do
    assert BidTopUpJob.perform params

    result = TopUpHistory.first
    assert_not_nil result
    assert_not_nil result.completed_at

    bids_size = Bid.where(:user => TopUpHistory.first.user).size
    assert_equal 2, bids_size
  end
end
