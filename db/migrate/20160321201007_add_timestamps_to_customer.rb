class AddTimestampsToCustomer < ActiveRecord::Migration
  def self.up # Or `def up` in 3.1
      change_table :customers do |t|
          t.timestamps
      end
  end
  def self.down # Or `def down` in 3.1
      remove_column :customers, :created_at
      remove_column :customers, :updated_at
  end
end
