class CreateUsersLocations < ActiveRecord::Migration
  def change
    drop_table :users_locations if table_exists? :users_locations
    create_table :users_locations do |t|
      t.integer :user_id, null: false
      t.integer :location_id, null: false

      t.timestamps null: false
    end
    add_index :users_locations, [:user_id, :location_id], unique: true
  end
end
