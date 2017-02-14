# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161205092227) do

  create_table "addresses", force: :cascade do |t|
    t.string   "house_number", limit: 10,  null: false
    t.string   "street_name",  limit: 255, null: false
    t.string   "postal_code",  limit: 6,   null: false
    t.string   "apartment",    limit: 15
    t.string   "city",         limit: 255, null: false
    t.integer  "province_id",  limit: 4,   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "addresses", ["postal_code"], name: "index_addresses_on_postal_code", using: :btree
  add_index "addresses", ["province_id"], name: "fk_rails_0286d8b237", using: :btree

  create_table "bids", force: :cascade do |t|
    t.integer  "category_id",       limit: 4,                null: false
    t.boolean  "available",                   default: true, null: false
    t.integer  "user_id",           limit: 4,                null: false
    t.integer  "purchase_id",       limit: 4
    t.datetime "consumed_at"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "top_up_history_id", limit: 4
    t.integer  "lock_version",      limit: 4, default: 1,    null: false
  end

  add_index "bids", ["category_id"], name: "fk_rails_cc1e3b0890", using: :btree
  add_index "bids", ["consumed_at", "user_id", "category_id"], name: "index_bids_on_consumed_at_and_user_id_and_category_id", using: :btree
  add_index "bids", ["purchase_id"], name: "fk_rails_e924c01d0d", using: :btree
  add_index "bids", ["top_up_history_id"], name: "fk_rails_3082f4bd8a", using: :btree
  add_index "bids", ["user_id"], name: "fk_rails_e173de2ed3", using: :btree

  create_table "business_tags", force: :cascade do |t|
    t.integer  "business_id", limit: 4
    t.integer  "tag_id",      limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "business_tags", ["business_id", "tag_id"], name: "index_business_tags_on_business_id_and_tag_id", unique: true, using: :btree
  add_index "business_tags", ["tag_id"], name: "fk_rails_7387c97f52", using: :btree

  create_table "businesses", force: :cascade do |t|
    t.integer  "user_id",      limit: 4,     null: false
    t.string   "company_name", limit: 255,   null: false
    t.string   "phone_number", limit: 15,    null: false
    t.text     "biography",    limit: 65535
    t.string   "website",      limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "businesses", ["user_id"], name: "index_businesses_on_user_id", unique: true, using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 50, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "alpha2",     limit: 2,   null: false
    t.string   "alpha3",     limit: 3,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "countries", ["alpha2"], name: "index_countries_on_alpha2", unique: true, using: :btree
  add_index "countries", ["alpha3"], name: "index_countries_on_alpha3", unique: true, using: :btree
  add_index "countries", ["name"], name: "index_countries_on_name", unique: true, using: :btree

  create_table "estimates", force: :cascade do |t|
    t.string   "summary",             limit: 150,                            null: false
    t.text     "description",         limit: 65535
    t.decimal  "price",                             precision: 10, scale: 2, null: false
    t.decimal  "duration",                          precision: 8,  scale: 2, null: false
    t.boolean  "inspection_required"
    t.integer  "quote_id",            limit: 4,                              null: false
    t.integer  "quantifier_id",       limit: 4,                              null: false
    t.date     "accepted_at"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  add_index "estimates", ["quantifier_id"], name: "fk_rails_6c756dfb79", using: :btree
  add_index "estimates", ["quote_id"], name: "fk_rails_13bd257d39", using: :btree

  create_table "feedbacks", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.text     "content",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "locations", force: :cascade do |t|
    t.integer  "address_id", limit: 4
    t.decimal  "latitude",               precision: 16, scale: 13,                null: false
    t.decimal  "longitude",              precision: 16, scale: 13,                null: false
    t.boolean  "visible",                                          default: true, null: false
    t.string   "name",       limit: 255
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
  end

  add_index "locations", ["address_id"], name: "index_locations_on_address_id", unique: true, using: :btree
  add_index "locations", ["latitude", "longitude"], name: "index_locations_on_latitude_and_longitude", using: :btree

  create_table "measurement_groups", force: :cascade do |t|
    t.string   "name",       limit: 100,             null: false
    t.integer  "group_id",   limit: 4,               null: false
    t.integer  "project_id", limit: 4,               null: false
    t.integer  "order",      limit: 4,   default: 0, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "measurement_groups", ["project_id", "name"], name: "index_measurement_groups_on_project_id_and_name", unique: true, using: :btree
  add_index "measurement_groups", ["project_id", "order"], name: "index_measurement_groups_on_project_id_and_order", unique: true, using: :btree
  add_index "measurement_groups", ["project_id"], name: "index_measurement_groups_on_project_id", using: :btree

  create_table "measurements", force: :cascade do |t|
    t.decimal  "value",                                  precision: 10, scale: 4, null: false
    t.integer  "unit_quantifier_id",           limit: 4
    t.integer  "classification_quantifier_id", limit: 4
    t.integer  "measurement_group_id",         limit: 4,                          null: false
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
  end

  add_index "measurements", ["measurement_group_id"], name: "fk_rails_5ba9bb678b", using: :btree

  create_table "notification_templates", force: :cascade do |t|
    t.string   "summary_key",    limit: 255, null: false
    t.string   "body_key",       limit: 255, null: false
    t.integer  "classification", limit: 4,   null: false
    t.integer  "preference_id",  limit: 4,   null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "notification_templates", ["preference_id"], name: "fk_rails_17b3e30bb7", using: :btree
  add_index "notification_templates", ["summary_key", "classification", "preference_id"], name: "notification_template_unique_idx", unique: true, using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id",                  limit: 4,                 null: false
    t.integer  "notification_template_id", limit: 4,                 null: false
    t.boolean  "seen",                               default: false, null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "notifications", ["notification_template_id"], name: "fk_rails_2fb35253bd", using: :btree
  add_index "notifications", ["seen", "user_id"], name: "index_notifications_on_seen_and_user_id", using: :btree
  add_index "notifications", ["user_id"], name: "fk_rails_b080fb4855", using: :btree

  create_table "packages", force: :cascade do |t|
    t.string   "name",           limit: 255,                          null: false
    t.integer  "quantity",       limit: 4,                            null: false
    t.decimal  "price_per_unit",             precision: 10, scale: 2, null: false
    t.decimal  "total",                      precision: 10, scale: 2, null: false
    t.datetime "inactivated_at"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "a_file_name",    limit: 255, null: false
    t.string   "a_content_type", limit: 255, null: false
    t.integer  "a_file_size",    limit: 4,   null: false
    t.datetime "a_updated_at",               null: false
    t.string   "generated_name", limit: 255, null: false
    t.integer  "user_id",        limit: 4,   null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "pictures", ["generated_name"], name: "index_pictures_on_generated_name", unique: true, using: :btree
  add_index "pictures", ["user_id"], name: "fk_project_users", using: :btree

  create_table "preferences", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "project_meta_data", force: :cascade do |t|
    t.integer  "project_id",          limit: 4, null: false
    t.date     "start_date",                    null: false
    t.date     "cut_off_date"
    t.boolean  "entry_required"
    t.boolean  "can_disturb"
    t.boolean  "show_address"
    t.boolean  "providing_materials"
    t.integer  "quantifier_id",       limit: 4, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "project_meta_data", ["project_id"], name: "index_project_meta_data_on_project_id", unique: true, using: :btree
  add_index "project_meta_data", ["quantifier_id"], name: "fk_rails_c939be3204", using: :btree

  create_table "project_pictures", force: :cascade do |t|
    t.integer  "project_id", limit: 4,                 null: false
    t.integer  "picture_id", limit: 4,                 null: false
    t.boolean  "default",              default: false, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "project_pictures", ["picture_id"], name: "fk_rails_e49e009bac", using: :btree
  add_index "project_pictures", ["project_id", "picture_id"], name: "index_project_pictures_on_project_id_and_picture_id", unique: true, using: :btree
  add_index "project_pictures", ["project_id"], name: "index_project_pictures_on_project_id", using: :btree

  create_table "project_summaries", force: :cascade do |t|
    t.decimal  "latitude",                precision: 16, scale: 13, null: false
    t.decimal  "longitude",               precision: 16, scale: 13, null: false
    t.integer  "project_id",  limit: 4,                             null: false
    t.integer  "picture_id",  limit: 4,                             null: false
    t.string   "title",       limit: 150,                           null: false
    t.string   "picture_url", limit: 255,                           null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "project_summaries", ["picture_id"], name: "fk_rails_b3c1ec9104", using: :btree
  add_index "project_summaries", ["project_id", "latitude", "longitude"], name: "project_summary_major_idx", using: :btree
  add_index "project_summaries", ["project_id"], name: "index_project_summaries_on_project_id", unique: true, using: :btree

  create_table "project_tags", force: :cascade do |t|
    t.integer  "project_id", limit: 4, null: false
    t.integer  "tag_id",     limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "project_tags", ["project_id", "tag_id"], name: "index_project_tags_on_project_id_and_tag_id", unique: true, using: :btree
  add_index "project_tags", ["tag_id"], name: "fk_rails_980b91da53", using: :btree

  create_table "projects", force: :cascade do |t|
    t.integer  "state",               limit: 1,     default: 1, null: false
    t.string   "title",               limit: 100,               null: false
    t.string   "summary",             limit: 250,               null: false
    t.text     "description",         limit: 65535
    t.text     "additional_comments", limit: 65535
    t.integer  "user_id",             limit: 4,                 null: false
    t.integer  "location_id",         limit: 4,                 null: false
    t.datetime "published_at"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "projects", ["created_at"], name: "index_projects_on_created_at", using: :btree
  add_index "projects", ["location_id"], name: "fk_rails_b10c80c09a", using: :btree
  add_index "projects", ["user_id", "title"], name: "index_projects_on_user_id_and_title", using: :btree

  create_table "promo_codes", force: :cascade do |t|
    t.datetime "start_date",                           null: false
    t.datetime "end_date"
    t.integer  "category_id", limit: 4,                null: false
    t.string   "code",        limit: 25,               null: false
    t.decimal  "discount",               precision: 3, null: false
    t.string   "description", limit: 50,               null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "promo_codes", ["category_id"], name: "fk_rails_2fdb37ad68", using: :btree
  add_index "promo_codes", ["code", "category_id", "start_date", "end_date"], name: "promo_code_lookup_idx", using: :btree
  add_index "promo_codes", ["code"], name: "index_promo_codes_on_code", using: :btree

  create_table "provinces", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "code",       limit: 2,   null: false
    t.integer  "country_id", limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "provinces", ["code"], name: "index_provinces_on_code", using: :btree
  add_index "provinces", ["country_id"], name: "fk_rails_6fd6e7d17e", using: :btree
  add_index "provinces", ["name", "code"], name: "index_provinces_on_name_and_code", unique: true, using: :btree
  add_index "provinces", ["name"], name: "index_provinces_on_name", using: :btree

  create_table "purchases", force: :cascade do |t|
    t.string   "transaction_id", limit: 255,                          null: false
    t.integer  "user_id",        limit: 4,                            null: false
    t.integer  "package_id",     limit: 4,                            null: false
    t.integer  "promo_code_id",  limit: 4
    t.decimal  "discount",                   precision: 10, scale: 2
    t.decimal  "total",                      precision: 10, scale: 2, null: false
    t.string   "brand",          limit: 255
    t.string   "last_4",         limit: 255
    t.string   "exp_month",      limit: 255
    t.integer  "exp_year",       limit: 4
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  add_index "purchases", ["package_id"], name: "fk_rails_42ce532de2", using: :btree
  add_index "purchases", ["promo_code_id"], name: "fk_rails_491c938c85", using: :btree
  add_index "purchases", ["transaction_id"], name: "index_purchases_on_transaction_id", unique: true, using: :btree
  add_index "purchases", ["user_id"], name: "index_purchases_on_user_id", using: :btree

  create_table "quantifiers", force: :cascade do |t|
    t.string   "quantifier",  limit: 50, null: false
    t.integer  "category_id", limit: 4,  null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "quantifiers", ["category_id"], name: "fk_rails_29dd764d5b", using: :btree
  add_index "quantifiers", ["quantifier", "category_id"], name: "index_quantifiers_on_quantifier_and_category_id", unique: true, using: :btree

  create_table "quotes", force: :cascade do |t|
    t.integer  "project_id",  limit: 4, null: false
    t.integer  "business_id", limit: 4, null: false
    t.integer  "bid_id",      limit: 4, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "quotes", ["bid_id"], name: "index_quotes_on_bid_id", unique: true, using: :btree
  add_index "quotes", ["business_id"], name: "fk_rails_d70dd27f25", using: :btree
  add_index "quotes", ["project_id", "business_id"], name: "index_quotes_on_project_id_and_business_id", unique: true, using: :btree

  create_table "rating_definitions", force: :cascade do |t|
    t.integer  "category_id",    limit: 4,   null: false
    t.string   "brackets",       limit: 255, null: false
    t.datetime "inactivated_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "rating_definitions", ["category_id"], name: "index_rating_definitions_on_category_id", using: :btree

  create_table "ratings", force: :cascade do |t|
    t.integer  "business_id",          limit: 4,     null: false
    t.integer  "rating_definition_id", limit: 4,     null: false
    t.integer  "rating",               limit: 4,     null: false
    t.integer  "user_id",              limit: 4,     null: false
    t.text     "comments",             limit: 65535, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "ratings", ["business_id", "rating_definition_id"], name: "index_ratings_on_business_id_and_rating_definition_id", using: :btree
  add_index "ratings", ["rating_definition_id"], name: "fk_rails_6004df2e4c", using: :btree
  add_index "ratings", ["user_id"], name: "fk_rails_a7dfeb9f5f", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "roles", ["name"], name: "index_roles_on_name", unique: true, using: :btree

  create_table "spam_reports", force: :cascade do |t|
    t.integer  "source_id",   limit: 4
    t.integer  "target_type", limit: 4, null: false
    t.integer  "target_id",   limit: 4, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "spam_reports", ["target_type", "target_id"], name: "index_spam_reports_on_target_type_and_target_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 50, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "terms_and_conditions", force: :cascade do |t|
    t.text     "eula",           limit: 65535, null: false
    t.datetime "inactivated_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "top_up_histories", force: :cascade do |t|
    t.integer  "user_id",       limit: 4, null: false
    t.integer  "owed",          limit: 4, null: false
    t.integer  "promo_code_id", limit: 4
    t.datetime "completed_at"
    t.datetime "period_start",            null: false
    t.datetime "period_end",              null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "top_up_histories", ["promo_code_id"], name: "fk_rails_0c4b1bb5fe", using: :btree
  add_index "top_up_histories", ["user_id", "period_start", "period_end"], name: "top_ups_unique_for_period_user", unique: true, using: :btree

  create_table "user_acceptance_of_terms", force: :cascade do |t|
    t.integer  "user_id",                 limit: 4, null: false
    t.integer  "terms_and_conditions_id", limit: 4, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "user_acceptance_of_terms", ["terms_and_conditions_id"], name: "fk_rails_3b37047fbd", using: :btree
  add_index "user_acceptance_of_terms", ["user_id", "terms_and_conditions_id"], name: "user_and_terms_unique_idx", unique: true, using: :btree

  create_table "user_preferences", force: :cascade do |t|
    t.integer  "user_id",       limit: 4,                null: false
    t.integer  "preference_id", limit: 4,                null: false
    t.boolean  "email",                   default: true, null: false
    t.boolean  "internal",                default: true, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "user_preferences", ["preference_id"], name: "fk_rails_d307539a7a", using: :btree
  add_index "user_preferences", ["user_id", "preference_id"], name: "index_user_preferences_on_user_id_and_preference_id", unique: true, using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.integer  "role_id",    limit: 4, null: false
    t.integer  "user_id",    limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "user_roles", ["role_id"], name: "fk_rails_3369e0d5fc", using: :btree
  add_index "user_roles", ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,             null: false
    t.string   "first_name",             limit: 255,             null: false
    t.string   "last_name",              limit: 255,             null: false
    t.string   "unconfirmed_email",      limit: 255
    t.string   "encrypted_password",     limit: 255,             null: false
    t.integer  "address_id",             limit: 4,               null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",        limit: 4,   default: 0, null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
  end

  add_index "users", ["address_id"], name: "fk_rails_eb2fc738e4", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "users_locations", force: :cascade do |t|
    t.integer  "user_id",     limit: 4, null: false
    t.integer  "location_id", limit: 4, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "users_locations", ["location_id"], name: "fk_rails_8c1ca9a83c", using: :btree
  add_index "users_locations", ["user_id", "location_id"], name: "index_users_locations_on_user_id_and_location_id", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      limit: 191,        null: false
    t.integer  "item_id",        limit: 4,          null: false
    t.string   "event",          limit: 255,        null: false
    t.string   "whodunnit",      limit: 255
    t.text     "object",         limit: 4294967295
    t.datetime "created_at"
    t.text     "object_changes", limit: 4294967295
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "addresses", "provinces"
  add_foreign_key "bids", "categories"
  add_foreign_key "bids", "purchases"
  add_foreign_key "bids", "top_up_histories"
  add_foreign_key "bids", "users"
  add_foreign_key "business_tags", "businesses"
  add_foreign_key "business_tags", "tags"
  add_foreign_key "businesses", "users"
  add_foreign_key "estimates", "quantifiers"
  add_foreign_key "estimates", "quotes"
  add_foreign_key "locations", "addresses"
  add_foreign_key "measurement_groups", "projects"
  add_foreign_key "measurements", "measurement_groups"
  add_foreign_key "notification_templates", "preferences"
  add_foreign_key "notifications", "notification_templates"
  add_foreign_key "notifications", "users"
  add_foreign_key "pictures", "users", name: "fk_project_users"
  add_foreign_key "project_meta_data", "projects"
  add_foreign_key "project_meta_data", "quantifiers"
  add_foreign_key "project_pictures", "pictures"
  add_foreign_key "project_pictures", "projects"
  add_foreign_key "project_summaries", "pictures"
  add_foreign_key "project_summaries", "projects"
  add_foreign_key "project_tags", "projects"
  add_foreign_key "project_tags", "tags"
  add_foreign_key "projects", "locations"
  add_foreign_key "projects", "users"
  add_foreign_key "promo_codes", "categories"
  add_foreign_key "provinces", "countries"
  add_foreign_key "purchases", "packages"
  add_foreign_key "purchases", "promo_codes"
  add_foreign_key "purchases", "users"
  add_foreign_key "quantifiers", "categories"
  add_foreign_key "quotes", "bids"
  add_foreign_key "quotes", "businesses"
  add_foreign_key "quotes", "projects"
  add_foreign_key "rating_definitions", "categories"
  add_foreign_key "ratings", "businesses"
  add_foreign_key "ratings", "rating_definitions"
  add_foreign_key "ratings", "users"
  add_foreign_key "top_up_histories", "promo_codes"
  add_foreign_key "top_up_histories", "users"
  add_foreign_key "user_acceptance_of_terms", "terms_and_conditions", column: "terms_and_conditions_id"
  add_foreign_key "user_acceptance_of_terms", "users"
  add_foreign_key "user_preferences", "preferences"
  add_foreign_key "user_preferences", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "users", "addresses"
  add_foreign_key "users_locations", "locations"
  add_foreign_key "users_locations", "users"
end
