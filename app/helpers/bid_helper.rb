module BidHelper
  @logger = MyLogger.factory(self)

  def self.create_bids(quantity, purchase, top_up_history)
    category = purchase.nil? ? Category.find_by_name(BID_CATEGORY_FREE) : Category.find_by_name(BID_CATEGORY_PAID)
    user = purchase.nil? ? top_up_history.user : purchase.user
    quantity.times {
      result = Bid.create :category => category, :available => true, :user => user, :purchase => purchase,
                          :top_up_history => top_up_history
      unless result.valid?
        raise ArgumentError.new "errors: #{result.errors.full_messages}"
      end
    }
  end

  def self.get_users_available_for_top_up(start_date, end_date)
    unless start_date.is_a? Time
      raise ArgumentError.new "{start_date} expected to be an Time object"
    end
    unless end_date.is_a? Time
      raise ArgumentError.new "{end_date} expected to be an Time object"
    end

    sql = "SELECT user_id, COUNT(id) AS 'consumed' " \
            "FROM bids " \
            "WHERE consumed_at >= '#{start_date}' AND consumed_at <= '#{end_date}' AND category_id = #{Category.find_by_name(BID_CATEGORY_FREE).id} " \
            "GROUP BY user_id;"
    return SqlHelper.execute_return(sql, method(:populator))
  end

  def self.create_top_up_history_for_accounts(period_start, period_end, accounts)
    histories = []
    accounts.each { |record|
      TopUpHistory.transaction do
        user_id = record[:user_id]
        owed = record[:count]
        create_accounts_top_up(user_id, owed, period_start, period_end, histories)
      end
    }
    return histories
  end

  def self.create_accounts_top_up(user_id, owed, period_start, period_end, histories=nil, clamped=true)
    owed = clamped ? owed.clamp(0,MAX_FREE_BIDS) : owed
    begin
      history = TopUpHistory.new :user_id => user_id, :owed => owed, :period_start => period_start,
                                 :period_end => period_end
      history.save!
      BidTopUpJob.enqueue history.id
      if histories
        histories << history
      end
    rescue ActiveRecord::RecordNotUnique => e
      @logger.warn "unique violation for user_id: #{user_id} for date range: #{period_start} - #{period_end}"
    end
  end

  private
    def self.populator(data)
      return { :user_id => data[0], :count => data[1]}
    end

end
