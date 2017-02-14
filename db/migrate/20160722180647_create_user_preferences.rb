class CreateUserPreferences < ActiveRecord::Migration
  def change
    drop_table :user_preferences if table_exists? :user_preferences
    create_table :user_preferences do |t|
      t.integer :user_id, null: false
      t.integer :preference_id, null: false
      t.boolean :email, null: false, default: true
      t.boolean :internal, null: false, default: true

      t.timestamps null: false
    end
    add_index :user_preferences, [:user_id, :preference_id], :unique => true
    add_foreign_key :user_preferences, :users
    add_foreign_key :user_preferences, :preferences
  end
end
