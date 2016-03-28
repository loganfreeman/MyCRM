class CreateConference < ActiveRecord::Migration
  def self.up
    create_table :conferences, force: true do |t|
      t.string :uuid,   limit: 36
      t.references :user
      t.integer :assigned_to
      t.string :name,   limit: 64, null: false, default: ""
      t.string :access, limit: 8, default: "Public" # %w(Private Public Shared)
      t.string :status, limit: 64
      # Dates.
      t.date :starts_on
      t.date :ends_on
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :conferences, [:user_id, :name, :deleted_at], unique: true
    add_index :conferences, :assigned_to
  end

  def self.down
    drop_table :conferences
  end
end
