class CreateMeal < ActiveRecord::Migration
  def self.up
    create_table :meals do |t|
      t.belongs_to :itinerary_items
      t.timestamps

      t.decimal :breakfast, precision: 7, scale: 2
      t.decimal :lunch, precision: 7, scale: 2
      t.decimal :dinner, precision: 7, scale: 2
      t.string :currency
    end
  end
  def  self.down
    drop_table :meals
  end
end
