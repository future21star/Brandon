source 'https://rubygems.org'
ruby '2.3.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'

gem 'railties', '~> 4.2', '>= 4.2.6'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks','~> 2.5.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'mailcatcher', '~> 0.6.4'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Custom Gems
gem 'mysql2', '~> 0.4.2'
gem 'i18n', '~> 0.7.0'
gem 'logging', '~> 2.1'
gem 'paper_trail', '~> 5.2'
gem 'recaptcha', '~> 3.3', require: "recaptcha/rails"
gem 'geocoder', '~> 1.3.7'
gem 'stripe', '~> 1.43', '>= 1.43.1'
gem 'aasm', '~> 4.11'
gem 'devise', '~> 4.1', '>= 4.1.1'
gem 'figaro', '~> 1.1', '>= 1.1.1'
gem 'fog', '~> 1.38'
gem 'paperclip', '~> 5.0'
gem 'strip_attributes', '~> 1.8'
gem 'actionmailer', '~> 4.2.6'
gem 'exception_notification', '~> 4.2', '>= 4.2.1'
gem 'compass-rails', '~> 3.0', '>= 3.0.2'

# resque
gem 'resque', '~> 1.26'
gem 'resque-scheduler', '~> 4.3'
gem 'resque-cleaner', '~> 0.3.2'
gem 'resque-history', '~> 1.12', '>= 1.12.3'
gem 'resque-retry', '~> 1.5'

# Validators
gem 'email_validation', '~> 1.2', '>= 1.2.1'
gem 'validate_url', '~> 1.0', '>= 1.0.2'
gem 'phonelib', '~> 0.6.2'
gem 'validates_zipcode', '~> 0.0.9'
gem 'validates_email_format_of', '~> 1.6', '>= 1.6.3'

# UI stuffs
gem 'will_paginate', '~> 3.1'
gem 'react-rails', '~> 1.8', '>= 1.8.1'
gem 'formsy-react-rails', '~> 0.18.1'
gem 'js-routes', '~> 1.2', '>= 1.2.8'
gem 'browserify-rails', '~> 3.2'
gem 'jquery-turbolinks'
gem 'nprogress-rails'
gem 'haml-rails'
gem 'chartkick', '~> 2.2.2'

# Server
group :development do
  gem 'passenger', '~> 5.0', '>= 5.0.30'
end

group :test do
  gem 'debase', '~> 0.2.1'
  #gem 'ruby-debug-ide', '~> 0.6.0'
  gem 'mocha', '~> 1.2'
  gem 'simplecov', :require => false
end

# Deployment
group :development do
  gem 'schema_to_scaffold', '~> 0.7.2'
  gem 'capistrano', '~> 3.6', '>= 3.6.1'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-npm', '~> 1.0', '>= 1.0.2'
  # gem 'capistrano-passenger'
end
