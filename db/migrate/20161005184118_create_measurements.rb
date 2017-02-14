class CreateMeasurements < ActiveRecord::Migration
  def change
    drop_table :measurements if table_exists? :measurements
    create_table :measurements do |t|
      t.decimal :value, precision: 10, scale: 4, null: false
      t.references :unit_quantifier
      t.references :classification_quantifier
      # t.integer :unit, null: false
      # t.integer :classification, null: false
      t.integer :measurement_group_id, null: false

      t.timestamps null: false
    end
    # add_foreign_key :measurements, :quantifiers, {:column => 'unit', :name => 'fk_unit_quantifier'}
    # add_foreign_key :measurements, :quantifiers, {:column => 'classification', :name => 'fk_claissification_quantifier'}
    add_foreign_key :measurements, :measurement_groups
  end
end
