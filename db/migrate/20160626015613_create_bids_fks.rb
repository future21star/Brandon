class CreateBidsFks < ActiveRecord::Migration
  def up
    add_foreign_key :bids, :users
    add_foreign_key :bids, :purchases
    add_foreign_key :bids, :categories
  end
  def down
    remove_foreign_key :bids, :users
    remove_foreign_key :bids, :purchases
    remove_foreign_key :bids, :categories
  end
end
