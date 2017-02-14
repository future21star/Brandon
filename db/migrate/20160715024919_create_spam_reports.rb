class CreateSpamReports < ActiveRecord::Migration
  def change
    create_table :spam_reports do |t|
      t.integer :source_id, null: true
      t.integer :target_type, null: false
      t.integer :target_id, null: false

      t.timestamps null: false
    end
    add_index :spam_reports, [:target_type, :target_id]
  end
end
