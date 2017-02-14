require_relative '../../config/environment'
require_relative '../helper'

namespace :ops do
  logger = MyLogger.factory('BidTopUpTask')
  desc "Fills up user accounts with less than the max free bids"
  task :top_up_bids => :environment do
    start_date = ENV["START_DATE"].to_time.zone_is_utc
    end_date = ENV["END_DATE"].to_time.zone_is_utc

    logger.info "Gathering accounts that need topped up"
    # This query is safe for running point in time and determining the correct amount of bids.
    accounts = BidHelper.get_users_available_for_top_up(start_date, end_date)
    size = accounts.size

    logger.info "Total number of accounts to top up #{size}"
    # This call gracefully handles a unqiue constraint violation and therefore makes the job multi-run safe
    BidHelper.create_top_up_history_for_accounts start_date, end_date, accounts

    logger.info "Finished generating initial top up history records for #{start_date}-#{end_date}"
  end
end


