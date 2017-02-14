class CreateUserAcceptanceOfTerms < ActiveRecord::Migration
  def change
    drop_table :user_acceptance_of_terms if table_exists? :user_acceptance_of_terms
    create_table :user_acceptance_of_terms do |t|
      t.integer :user_id, null: false
      t.integer :terms_and_conditions_id, null: false

      t.timestamps null: false
    end
    add_index :user_acceptance_of_terms, [:user_id, :terms_and_conditions_id], unique: true, name: 'user_and_terms_unique_idx'
    add_foreign_key :user_acceptance_of_terms, :users
    add_foreign_key :user_acceptance_of_terms, :terms_and_conditions, column: 'terms_and_conditions_id'
  end
end
