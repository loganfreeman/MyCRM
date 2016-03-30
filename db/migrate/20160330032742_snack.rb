class Snack < ActiveRecord::Migration
  def self.up
    create_table :snacks do |t|
      t.belongs_to :itinerary_items

      t.string :kind
      t.string :description
      t.decimal :cost, precision: 7, scale: 2
      t.string :currency
      t.timestamps
    end
  end
  def self.down
    drop_table :snacks
  end
end
