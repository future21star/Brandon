class CreateEstimates < ActiveRecord::Migration
  def change
    drop_table :estimates if table_exists? :estimates
    create_table :estimates do |t|
      t.string :summary, null: false, limit: 150
      t.text :description
      t.decimal :price, null: false, precision: 10, scale: 2
      t.decimal :duration, null: false, precision: 8, scale: 2
      t.boolean :inspection_required
      t.integer :quote_id, null: false
      t.integer :quantifier_id, null: false
      t.date    :accepted_at

      t.timestamps null: false
    end
  end
end
