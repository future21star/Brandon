class CreateRatings < ActiveRecord::Migration
  def change
    drop_table :ratings if table_exists? :ratings
    create_table :ratings do |t|
      t.integer :business_id, null: false
      t.integer :rating_definition_id, null: false
      t.integer :rating, null: false
      t.integer :user_id, null: false
      t.text :comments, null: false

      t.timestamps null: false
    end
    add_foreign_key :ratings, :businesses
    add_foreign_key :ratings, :rating_definitions
    add_foreign_key :ratings, :users
    add_index :ratings, [:business_id, :rating_definition_id]
  end
end
