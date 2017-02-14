class CreateBusinessTagsFks < ActiveRecord::Migration
  def up
    add_foreign_key :business_tags, :businesses
    add_foreign_key :business_tags, :tags
  end
  def down
    remove_foreign_key :business_tags, :businesses
    remove_foreign_key :business_tags, :tags
  end
end
