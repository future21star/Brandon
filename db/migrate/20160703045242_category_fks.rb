class CategoryFks < ActiveRecord::Migration
  def up
    add_foreign_key :quantifiers, :categories
  end
  def down
    remove_foreign_key :quantifiers, :categories
  end
end
