class CreateTransport < ActiveRecord::Migration
  def self.up
    create_table :transports, force: true do |t|
      t.string :uuid,   limit: 36
      t.references :user
      t.integer :assigned_to
      t.string :name,   limit: 64, null: false, default: ""
      t.string :access, limit: 8, default: "Public" # %w(Private Public Shared)
      t.string :status, limit: 64
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :transports, [:user_id, :name, :deleted_at], unique: true
    add_index :transports, :assigned_to
  end

  def self.down
    drop_table :transports
  end
end
