class CreateQuantifiers < ActiveRecord::Migration
  def change
    create_table :quantifiers do |t|
      t.string :quantifier, null: false, :limit => 50
      t.integer :category_id, null: false

      t.timestamps null: false
    end
    add_index :quantifiers, [:quantifier, :category_id], unique: true
  end
end
