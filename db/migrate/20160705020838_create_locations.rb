class CreateLocations < ActiveRecord::Migration
  def change
    drop_table :locations if table_exists? :locations
    create_table :locations do |t|
      t.integer :address_id, null: true
      t.decimal :latitude, null: false, precision: 16, scale: 13
      t.decimal :longitude, null: false, precision: 16, scale: 13
      t.boolean :visible, null: false, default: true
      t.string :name

      t.timestamps null: false
    end
    add_index :locations, [:latitude, :longitude]
    add_index :locations, :address_id, unique: true
  end
end
