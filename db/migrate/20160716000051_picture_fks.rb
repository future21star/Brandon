class PictureFks < ActiveRecord::Migration
  def up
    add_foreign_key :pictures, :users, :name => 'fk_project_users'
    add_foreign_key :project_pictures, :projects
    add_foreign_key :project_pictures, :pictures
  end
  def down
    remove_foreign_key :pictures, :users
    remove_foreign_key :project_pictures, :projects
    remove_foreign_key :project_pictures, :pictures
  end
end
