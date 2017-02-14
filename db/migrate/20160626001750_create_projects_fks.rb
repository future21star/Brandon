class CreateProjectsFks < ActiveRecord::Migration
  def up
    add_foreign_key :projects, :users
  end
  def down
    remove_foreign_key :projects, :users
  end
end
