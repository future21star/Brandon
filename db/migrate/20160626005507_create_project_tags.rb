class CreateProjectTags < ActiveRecord::Migration
  def change
    drop_table :project_tags if table_exists? :project_tags
    create_table :project_tags do |t|
      t.integer :project_id, null: false
      t.integer :tag_id, null: false

      t.timestamps null: false
    end
    add_index :project_tags, [:project_id, :tag_id], unique: true
  end
end
