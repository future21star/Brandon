class AddTopUpToBids < ActiveRecord::Migration
  def up
    add_column :bids, :top_up_history_id, :integer
    add_foreign_key :bids, :top_up_histories
  end
  def down
    remove_foreign_key :bids, :top_up_histories
    remove_column :bids, :top_up_history_id
  end
end
