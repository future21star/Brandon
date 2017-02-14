class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :house_number, null: false, limit: 10
      t.string :street_name, null: false
      t.string :postal_code, null: false, limit: 6
      t.string :apartment, limit: 15
      t.string :city, null: false
      t.integer :province_id, null: false

      t.timestamps null: false
    end
    add_index :addresses, :postal_code
  end
end
