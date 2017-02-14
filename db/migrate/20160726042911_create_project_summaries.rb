class CreateProjectSummaries < ActiveRecord::Migration
  def change
    drop_table :project_summaries if table_exists? :project_summaries
    create_table :project_summaries do |t|
      t.decimal :latitude, null: false, precision: 16, scale: 13
      t.decimal :longitude, null: false, precision: 16, scale: 13
      t.integer :project_id, null: false
      t.integer :picture_id, null: false
      t.string :title, null: false, limit:  150
      t.string :picture_url, null: false

      t.timestamps null: false
    end
    add_index :project_summaries, [:project_id, :latitude, :longitude], :name => "project_summary_major_idx"
    add_index :project_summaries, [:project_id], unique: true
  end
end
