class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name, null: false
      t.integer :quantity, null: false
      t.decimal :price_per_unit, null: false, precision: 10, scale: 2
      t.decimal :total, null: false, precision: 10, scale: 2
      t.datetime :inactivated_at

      t.timestamps null: false
    end
    add_foreign_key :purchases, :packages
  end
end
