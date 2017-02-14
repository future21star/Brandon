class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id, null: false
      t.integer :notification_template_id, null: false
      t.boolean :seen, null: false, default: false

      t.timestamps null: false
    end
    add_index :notifications, [:seen, :user_id]
  end
end
