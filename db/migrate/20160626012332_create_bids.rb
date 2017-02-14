class CreateBids < ActiveRecord::Migration
  def change
    drop_table :bids if table_exists? :bids
    create_table :bids do |t|
      t.integer :category_id, null: false
      t.boolean :available, default: true, null: false
      t.integer :user_id, null: false
      t.integer :purchase_id, null: true
      t.datetime :consumed_at

      t.timestamps null: false
    end
    add_index :bids, [:consumed_at, :user_id, :category_id]
  end
end
