# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# == 20161006053454 AddTopUpToBids: migrating ===================================
#     -- add_column(:bids, :top_up_history_id, :integer)
# -> 0.0832s
# -- add_foreign_key(:bids, :top_up_histories)
# -> 0.0834s
# == 20161006053454 AddTopUpToBids: migrated (0.1667s) ==========================

include Helper
User.transaction do

  Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each { |seed|
    short_name = File.basename(seed)
    puts " == Starting to seed #{short_name.b} file ==================================="
    load seed
    puts " == Finished seeding #{short_name} file ==================================="
  }

  canada = Country.find_by_alpha2 'CA'

  ontario = Province.find_by_code_and_country_id "ON", canada.id

  location = Location.new(latitude: 43.499032, longitude: -80.55443)
  address = Address.new(:house_number => 301, :street_name => "Mayview Cres", :postal_code => "n2v1p5",
              :apartment => 'B', :province => ontario, :city => "Waterloo", location: location)

  admin_role = Role.find_by_id(ROLE_ADMIN)
  business_role = Role.find_by_id(ROLE_BUSINESS)

  admin = User.new email: 'admin@' + COMPANY_NAME, password: 'testuser', address: address,
                   confirmed_at: '2016-06-30 04:02:09', first_name: "Brandon", last_name: "McCulligh"
  admin.user_roles << UserRole.new(user: admin, role: admin_role)
  admin.user_roles << UserRole.new(user: admin, role: business_role)
  admin.save

  location = location.dup
  address = address.dup
  address.location = location
  # This test data should be removed in the future
  user = User.new(email: 'test@' + COMPANY_NAME, password: 'testuser', address: address,
                  confirmed_at: '2016-06-30 04:02:09', first_name: "Cookie", last_name: "Monster")
  user.save

  location = location.dup
  address = address.dup
  address.location = location
  business_tag = BusinessTag.new(:tag => Tag.first)
  business_user = User.new(email: 'business@' + COMPANY_NAME, password: 'testuser', address: address,
                           confirmed_at: '2016-06-30 04:02:09', first_name: "God", last_name: "Zilla")
  business = Business.new :company_name => "Quotr", :phone_number => "5194965896", :user => business_user, :business_tags => [business_tag]
  save business
end
