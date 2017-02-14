class CreateUsers < ActiveRecord::Migration
  def change
    drop_table :users if table_exists? :users
    create_table :users do |t|
      t.string :email, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :unconfirmed_email
      t.string :encrypted_password, null: false
      t.integer :address_id, null: false

      t.timestamps null: false
    end
    add_index :users, :email, unique: true
  end
end
