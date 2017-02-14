class CreateProvinces < ActiveRecord::Migration
  def change
    drop_table :provinces if table_exists? :provinces
    create_table :provinces do |t|
      t.string :name, null: false
      t.string :code, null: false, limit: 2
      t.integer :country_id, null: false

      t.timestamps null: false
    end
    add_index :provinces, :code
    add_index :provinces, :name
    add_index :provinces, [:name, :code], unique: true
  end
end
