class CreateProjectMetaData < ActiveRecord::Migration
  def change
    drop_table :project_meta_data if table_exists? :project_meta_data
    create_table :project_meta_data do |t|
      t.integer :project_id, null: false
      t.date :start_date, null: false
      t.date :cut_off_date
      t.boolean :entry_required
      t.boolean :can_disturb
      t.boolean :show_address
      t.boolean :providing_materials
      t.integer :quantifier_id, null: false
      t.timestamps null: false
    end
    add_index :project_meta_data, :project_id, unique: true
  end
end
