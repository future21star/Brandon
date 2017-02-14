class CreateCountries < ActiveRecord::Migration
  def change
    drop_table :countries if table_exists? :countries
    create_table :countries do |t|
      t.string :name, null: false
      t.string :alpha2, null: false, limit: 2
      t.string :alpha3, null: false, limit: 3

      t.timestamps null: false
    end
    add_index :countries, :alpha2, unique: true
    add_index :countries, :alpha3, unique: true
    add_index :countries, :name, unique: true
  end
end
