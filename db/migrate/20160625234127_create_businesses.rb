class CreateBusinesses < ActiveRecord::Migration
  def change
    drop_table :businesses  if table_exists? :businesses
    create_table :businesses do |t|
      t.integer :user_id, null: false
      t.string :company_name, null: false
      t.string :phone_number, null: false, limit: 15
      t.text :biography
      t.string :website

      t.timestamps null: false
    end
    add_index :businesses, :user_id, unique: true
  end
end
