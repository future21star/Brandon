class LocationFks < ActiveRecord::Migration
  def up
    add_foreign_key :locations, :addresses
    add_foreign_key :users_locations, :users
    add_foreign_key :users_locations, :locations
    add_foreign_key :users, :addresses
    add_foreign_key :provinces, :countries
    add_foreign_key :addresses, :provinces
    add_foreign_key :projects, :locations
  end
  def down
    remove_foreign_key :locations, :addresses
    remove_foreign_key :users_locations, :users
    remove_foreign_key :users_locations, :locations
    remove_foreign_key :users, :addresses
    remove_foreign_key :provinces, :countries
    remove_foreign_key :addresses, :provinces
    remove_foreign_key :projects, :locations
  end
end
