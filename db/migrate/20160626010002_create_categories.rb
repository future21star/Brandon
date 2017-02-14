class CreateCategories < ActiveRecord::Migration
  def change
    drop_table :categories if table_exists? :categories
    create_table :categories do |t|
      t.string :name, null: false, :limit => 50

      t.timestamps null: false
    end
    add_index :categories, :name, unique: true
  end
end
