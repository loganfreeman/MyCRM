class CreateItinerary < ActiveRecord::Migration
  def self.up
    create_table :itineraries do |t|
      t.string :name
      t.timestamps null: false
    end
  end
  def self.down
    drop_table  :itineraries
  end
end
