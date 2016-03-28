class CreateItinerary < ActiveRecord::Migration
  def self.up
    create_table :itineraries, force: true do |t|
      t.timestamps null: false
      t.belongs_to :account
      t.string :uuid,   limit: 36
      t.references :user
      t.integer :assigned_to
      t.string :name,   limit: 64, null: false, default: ""
      t.string :access, limit: 8, default: "Public" # %w(Private Public Shared)
      t.string :status, limit: 64
      t.datetime :deleted_at
    end
    add_index :itineraries, [:user_id, :name, :deleted_at], unique: true
    add_index :itineraries, :assigned_to
  end
  def self.down
    drop_table  :itineraries
  end
end
