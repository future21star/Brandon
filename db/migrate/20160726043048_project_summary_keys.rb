class ProjectSummaryKeys < ActiveRecord::Migration
  def up
    add_foreign_key :project_summaries, :projects
    add_foreign_key :project_summaries, :pictures
  end
  def down
    remove_foreign_key :project_summaries, :projects
    remove_foreign_key :project_summaries, :pictures
  end
end
