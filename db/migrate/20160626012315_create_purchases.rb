class CreatePurchases < ActiveRecord::Migration
  def change
    drop_table :purchases if table_exists? :purchases
    create_table :purchases do |t|
      t.string :transaction_id, null: false
      t.integer :user_id, null: false
      t.integer :package_id, null: false
      t.integer :promo_code_id
      t.decimal :discount, precision: 10, scale: 2
      t.decimal :total, null: false, precision: 10, scale: 2
      t.string :brand, null: true
      t.string :last_4, null: true
      t.string :exp_month, null: true
      t.integer :exp_year, null: true

      t.timestamps null: false
    end
    add_index :purchases, :transaction_id, unique: true
    add_index :purchases, :user_id
  end
end
