class CreateMeasurementGroups < ActiveRecord::Migration
  def change
    drop_table :measurement_groups if table_exists? :measurement_groups
    create_table :measurement_groups do |t|
      t.string :name, null: false, :limit => 100
      t.integer :group_id, null: false
      t.integer :project_id, null: false
      t.integer :order, null: false, default: 0

      t.timestamps null: false
    end
    add_index :measurement_groups, :project_id
    add_index :measurement_groups, [:project_id, :order], unique: true
    add_index :measurement_groups, [:project_id, :name], unique: true
    add_foreign_key :measurement_groups, :projects
  end
end