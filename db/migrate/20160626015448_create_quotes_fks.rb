class CreateQuotesFks < ActiveRecord::Migration
  def up
    add_foreign_key :quotes, :projects
    add_foreign_key :quotes, :businesses
    add_foreign_key :quotes, :bids
  end
  def down
    remove_foreign_key :quotes, :projects
    remove_foreign_key :quotes, :businesses
    remove_foreign_key :quotes, :bids
  end
end
