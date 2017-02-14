# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# determine if we are loading for a database task or not
seeding = 0
db_task = ARGV.to_a.select {|t|
  seeding = t.starts_with?('db:seed') ? seeding += 1 : seeding
  t.starts_with?('db:')
}.count > 0

# Load constants unless we are a DB task as these cannot be loaded
unless db_task && seeding == 0
  # load a database object to ensure we can connect to the database
  Category.find_by_name(RATING_CATEGORY_GENERAL)
end




