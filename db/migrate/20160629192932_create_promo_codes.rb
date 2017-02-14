class CreatePromoCodes < ActiveRecord::Migration
  def change
    drop_table :promo_codes if table_exists? :promo_codes
    create_table :promo_codes do |t|
      t.datetime :start_date, null: false
      t.datetime :end_date, null: true
      t.integer :category_id, null: false
      t.string :code, null: false, limit: 25
      t.decimal :discount, null: false, precision: 3
      t.string :description, null: false, limit: 50

      t.timestamps null: false
    end
    add_index :promo_codes, :code
    add_index :promo_codes, [:code, :category_id, :start_date, :end_date], name: 'promo_code_lookup_idx'
    add_foreign_key :promo_codes, :categories
    add_foreign_key :purchases, :promo_codes
  end
end
