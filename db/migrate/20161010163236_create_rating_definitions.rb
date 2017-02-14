class CreateRatingDefinitions < ActiveRecord::Migration
  def change
    drop_table :rating_definitions if table_exists? :rating_definitions
    create_table :rating_definitions do |t|
      t.integer :category_id, null: false
      t.string :brackets, null: false
      t.datetime :inactivated_at

      t.timestamps null: false
    end
    add_foreign_key :rating_definitions, :categories
    add_index :rating_definitions, :category_id
  end
end
