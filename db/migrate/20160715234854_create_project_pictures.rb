class CreateProjectPictures < ActiveRecord::Migration
  def change
    create_table :project_pictures do |t|
      t.integer :project_id, null: false
      t.integer :picture_id, null: false
      t.boolean :default, null: false, default: false

      t.timestamps null: false
    end
    add_index :project_pictures, :project_id
    add_index :project_pictures, [:project_id, :picture_id], :unique =>  true
  end
end
