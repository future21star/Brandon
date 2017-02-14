require 'resque-history'
require 'resque-retry'
require_relative '../../config/my_logger'

class BaseJob
  extend Resque::Plugins::History
  extend Resque::Plugins::Retry
  extend Resque::Plugins::ExponentialBackoff
  include MyLogger

  @backoff_strategy = [0, 60, 180, 600, 3600] # retry right away, again in 1minute, 3m, 10m, 1hour
  @retry_delay_multiplicand_min = 0.2
  @retry_delay_multiplicand_max = 1.8

  give_up_callback do |exception, *args|
    logger.log_exception(exception, args)
  end
end
