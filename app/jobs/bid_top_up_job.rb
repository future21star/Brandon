
class BidTopUpJob < BaseJob

  @logger = MyLogger.factory(self)
  @queue = :bid_top_ups
  @class = BidTopUpJob

  def self.validate_request(top_up_history_id)
    if top_up_history_id.blank?
      raise ArgumentError.new "missing required parameter {top_up_history_id}"
    end

    unless top_up_history_id.is_a? Integer
      raise ArgumentError.new "{top_up_history_id} expected to be an integer"
    end
  end

  def self.create_params(top_up_history_id)
    return [:top_up_history_id => top_up_history_id]
  end

  def self.perform(params)
    @logger.info "Performing execution of #{@class} with params: #{params.inspect}"
    top_up_history_id = params[0]['top_up_history_id']
    validate_request top_up_history_id

    TopUpHistory.transaction do
      history = TopUpHistory.find_by_id! top_up_history_id
      unless history
        raise ArgumentError.new "Failed to find TopUpHistory with id #{top_up_history_id}"
      end
      unless history.completed_at.nil?
        @logger.warn "TopUpHistory with id #{top_up_history_id} has already been completed"
        return true
      end

      # mark the history for the top ups, execution
      BidHelper.create_bids(history.owed, nil, history)
      history.completed_at = Time.now.utc
      history.save
      return true
    end
  end

  def self.enqueue(top_up_history_id)
    validate_request top_up_history_id
    params = create_params(top_up_history_id)
    @logger.info "Creating #{@class} with top_up_history_id: #{top_up_history_id}"
    Resque.enqueue_to @queue, @class, params
  end
end
