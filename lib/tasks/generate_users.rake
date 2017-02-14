require_relative '../../config/environment'
require_relative '../helper'

include Helper

namespace :generate do
  @logger = MyLogger.factory('GenerateUsersTask')

  desc "Generates N number of users"
  task :users => :environment do
    n = ENV['AMOUNT'] ? ENV['AMOUNT'].to_i : 10
    business_users = ENV['BUSINESS'] ? true : false
    @logger.info "About to start generating #{n} users"
    n.times {
      if business_users
        save create_cooked_business
      else
        save create_cooked_user
      end
    }
    @logger.info "Finished generated #{n} users"
  end
end

