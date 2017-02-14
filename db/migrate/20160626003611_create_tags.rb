class CreateTags < ActiveRecord::Migration
  def change
    drop_table :tags if table_exists? :tags
    create_table :tags do |t|
      t.string :name, null: false, limit: 50

      t.timestamps null: false
    end
    add_index :tags, :name, unique: true
  end
end
