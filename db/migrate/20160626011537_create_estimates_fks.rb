class CreateEstimatesFks < ActiveRecord::Migration
  def up
    add_foreign_key :estimates, :quotes
    add_foreign_key :estimates, :quantifiers
  end
  def down
    remove_foreign_key :estimates, :quotes
    remove_foreign_key :estimates, :quantifiers
  end
end
