class CreateRoleFKs < ActiveRecord::Migration
  def up
    add_foreign_key :user_roles, :users
    add_foreign_key :user_roles, :roles
  end
  def down
    remove_foreign_key :user_roles, :users
    remove_foreign_key :user_roles, :roles
  end
end
