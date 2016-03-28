class CreateItineraryItem < ActiveRecord::Migration
  def self.up
    create_table :itinerary_items do |t|
      t.datetime :order_date
      t.belongs_to :itinerary, index: true
      t.timestamps null: false
    end
  end
  def self.down
    drop_table :itinerary_items
  end
end
