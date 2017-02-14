class CreatePreferences < ActiveRecord::Migration
  def change
    drop_table :preferences if table_exists? :preferences
    create_table :preferences do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
