class CreateProjectTagsFks < ActiveRecord::Migration
  def up
    add_foreign_key :project_tags, :projects
    add_foreign_key :project_tags, :tags
  end
  def down
    remove_foreign_key :project_tags, :projects
    remove_foreign_key :project_tags, :tags
  end
end
