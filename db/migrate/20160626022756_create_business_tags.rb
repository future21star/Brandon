class CreateBusinessTags < ActiveRecord::Migration
  def change
    create_table :business_tags do |t|
      t.integer :business_id
      t.integer :tag_id

      t.timestamps null: false
    end
    add_index :business_tags, [:business_id, :tag_id], unique: true
  end
end
