class CreateTopUpHistories < ActiveRecord::Migration
  def change
    drop_table :top_up_histories if table_exists? :top_up_histories
    create_table :top_up_histories do |t|
      t.integer :user_id, null: false
      t.integer :owed, null: false
      t.integer :promo_code_id
      t.datetime :completed_at
      t.datetime :period_start, null: false
      t.datetime :period_end, null: false

      t.timestamps null: false
    end
    add_foreign_key :top_up_histories, :users
    add_foreign_key :top_up_histories, :promo_codes
    add_index :top_up_histories, [:user_id, :period_start, :period_end], :unique => true, :name => 'top_ups_unique_for_period_user'
  end
end
