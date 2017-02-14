class CreateProjectMetaDataFks < ActiveRecord::Migration
  def up
    add_foreign_key :project_meta_data, :projects
    add_foreign_key :project_meta_data, :quantifiers
  end
  def down
    remove_foreign_key :project_meta_data, :projects
    remove_foreign_key :project_meta_data, :quantifiers
  end
end
