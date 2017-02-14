class CreatePurchaseFks < ActiveRecord::Migration
  def up
    add_foreign_key :purchases, :users
  end
  def down
    remove_foreign_key :purchases, :users
  end
end
