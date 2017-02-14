class CreateNotificationTemplates < ActiveRecord::Migration
  def change
    create_table :notification_templates do |t|
      t.string :summary_key, null: false
      t.string :body_key, null: false
      t.integer :classification, null: false
      t.integer :preference_id, null: false

      t.timestamps null: false
    end
    add_index :notification_templates, [:summary_key, :classification, :preference_id], unique: true, name: "notification_template_unique_idx"
    add_foreign_key :notification_templates, :preferences
  end
end
