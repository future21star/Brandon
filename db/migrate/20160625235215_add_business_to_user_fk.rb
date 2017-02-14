class AddBusinessToUserFk < ActiveRecord::Migration
  def up
    add_foreign_key :businesses, :users
  end
  def down
    remove_foreign_key :businesses, :users
  end
end
