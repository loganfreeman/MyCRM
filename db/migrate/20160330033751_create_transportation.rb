class CreateTransportation < ActiveRecord::Migration
  def self.up
    create_table :transportations do |t|
      t.belongs_to :itinerary_item
      t.timestamps
      t.string :car
      t.integer :car_number
      t.decimal :unit_cost, precision: 7, scale: 2
      t.string :currency
    end
  end
  def self.down
    drop_table :transportations
  end
end
