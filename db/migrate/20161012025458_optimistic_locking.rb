class OptimisticLocking < ActiveRecord::Migration
  def self.up
    add_column :bids, :lock_version, :integer, null: false, default: 1
  end

  def self.down
    remove_column :bids, :lock_version
  end
end
