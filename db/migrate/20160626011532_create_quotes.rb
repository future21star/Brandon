class CreateQuotes < ActiveRecord::Migration
  def change
    drop_table :quotes if table_exists? :quotes
    create_table :quotes do |t|
      t.integer :project_id, null: false
      t.integer :business_id, null: false
      t.integer :bid_id, null: false

      t.timestamps null: false
    end
    add_index :quotes, :bid_id, unique: true
    add_index :quotes, [:project_id, :business_id], unique: true
  end
end
