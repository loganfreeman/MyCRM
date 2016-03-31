class CreateGuideDriver < ActiveRecord::Migration
  def self.up
    create_table :guide_drivers do |t|
      t.belongs_to :itinerary_item
      t.timestamps
      t.integer :guide
      t.integer :driver
      t.decimal :tip, precision: 7, scale: 2
      t.decimal :other, precision: 7, scale: 2
      t.decimal :overtime, precision: 7, scale: 2
      t.string :currency
    end
  end
  def self.down
    drop_table :guide_drivers
  end
end
