require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

COMPANY_NAME='Quotr.ca'

module Quotr
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('app', 'rules', 'project');

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true


    config.action_mailer.default_options = {from: "no-reply@#{COMPANY_NAME}"}

    # Paper trail configuration
    config.paper_trail.enabled = true

    config.browserify_rails.commandline_options = "--transform reactify --extension=\".jsx\""

  end
end

HOST = Rails.application.secrets.host
SERVER_ADMIN = Rails.application.secrets.server_admin
ROLE_ADMIN = 1
ROLE_USER = 2
ROLE_BUSINESS=3
SUPPORTED_COUNTRIES = ["Canada", "United States"]
GENERATED_NAME_SIZE=100
UPLOADS_PATH = Rails.root.join('public', 'uploads')
PROJECT_PUBLISH_PERIOD_SECONDS = 1
API_KEY="AIzaSyDcJU_he-Oeynl9SGrk1Xyhmwv9ZsaR7nE"
MAPS_URL='https://www.google.com/maps/embed/v1/place?q={LAT},{LONG}&key=' + API_KEY
MAX_FREE_BIDS = 2
LOG_FILE = Rails.root.join('log', "#{ENV['RAILS_ENV']}.log")
DATE_STRING = "%Y-%m-%d %H:%M:%S:%L %z"
LOG_FORMAT = "[%d] [%-5l] [%c] - %m\n"

QUANTIFIER_CATEGORY_TIME = 'time'
QUANTIFIER_CATEGORY_DISTANCE = 'distance'
QUANTIFIER_CATEGORY_MEASUREMENT = 'measurement'

BID_CATEGORY_FREE = 'free'
BID_CATEGORY_PAID = 'paid'
RATING_CATEGORY_GENERAL = 'rating_general'
PROMO_CODE_PURCHASE = 'discount_dollar'
PROMO_CODE_REGISTRATION = 'discount_bids'

SOCIAL_MEDIA_TWITTER='http://www.twitter.com/QuotrSupport'
SOCIAL_MEDIA_FACEBOOK='http://www.facebook.com/QuotrSupport'
SOCIAL_MEDIA_INSTA='http://www.instagram.com/QuotrSupport'

BASE_FIELD_ERROR_TEXT='Please correct the fields in error below'

class Time
  def self.as_utc(time)
    return Time.utc(time.year, time.month, time.day, time.hour, time.min, time.sec)
  end

  def zone_is_utc
    Time.as_utc(self)
  end
end

class Numeric
  def clamp min, max
    [[self, max].min, min].max
  end
end

class String
  def to_b
    self.downcase == 'true'
  end
end

require 'logging'
require_relative 'my_logger'