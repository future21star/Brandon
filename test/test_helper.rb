ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require_relative 'models/base_model_test'
require_relative 'controllers/base_controller_test'
require_relative '../lib/helper'




class ActiveSupport::TestCase
  include Helper
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...


end
