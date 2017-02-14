class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.attachment :a, null: false
      t.string :generated_name, null: false
      t.integer :user_id, null: false


      t.timestamps null: false
    end
    add_index :pictures, :generated_name, :unique =>  true
  end
end
