class NotificationKeys < ActiveRecord::Migration
  def up
    add_foreign_key :notifications, :users
    add_foreign_key :notifications, :notification_templates
  end
  def down
    remove_foreign_key :notifications, :users
    remove_foreign_key :notifications, :notification_templates
  end
end
