class CreateProjects < ActiveRecord::Migration
  def change
    drop_table :projects if table_exists? :projects
    create_table :projects do |t|
      t.integer :state, limit: 1, null: false, default: 1
      t.string :title, null: false, limit: 100
      t.string :summary, null: false, limit:  250
      t.text :description
      t.text :additional_comments
      t.integer :user_id, null: false
      t.integer :location_id, null: false
      t.datetime :published_at, null: true

      t.timestamps null: false
    end
    add_index :projects, :created_at
    add_index :projects, [:user_id, :title]
  end
end
