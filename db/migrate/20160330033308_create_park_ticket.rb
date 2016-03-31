class CreateParkTicket < ActiveRecord::Migration
  def self.up
    create_table :park_tickets do |t|
      t.belongs_to :itinerary_item
      t.string :park
      t.decimal :cost, precision: 7, scale: 2
      t.string :currency

      t.timestamps
    end
  end
  def self.down
    drop_table :park_tickets
  end
end
