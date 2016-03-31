class CreateHotelReservation < ActiveRecord::Migration
  def self.up
    create_table :hotel_reservations do |t|
      t.belongs_to :itinerary_item
      t.timestamps
      t.string :hotel_name
      t.integer :room_number
      t.decimal :unit_cost, precision: 7, scale: 2
      t.string :currency
    end
  end
  def self.down
    drop_table :hotel_reservations
  end
end
