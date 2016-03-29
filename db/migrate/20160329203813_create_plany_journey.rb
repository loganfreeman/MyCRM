class CreatePlanyJourney < ActiveRecord::Migration
  def self.up
    create_table :plane_journeys do |t|
      t.boolean :booked
      t.boolean :paid
      t.decimal :cost, precision: 7, scale: 2

      t.timestamps
    end
  end
  def self.down
    drop_table :plane_journeys
  end
end
