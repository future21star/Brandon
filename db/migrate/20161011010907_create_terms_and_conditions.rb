class CreateTermsAndConditions < ActiveRecord::Migration
  def change
    drop_table :terms_and_conditions if table_exists? :terms_and_conditions
    create_table :terms_and_conditions do |t|
      t.text :eula, null: false
      t.datetime :inactivated_at

      t.timestamps null: false
    end
  end
end
