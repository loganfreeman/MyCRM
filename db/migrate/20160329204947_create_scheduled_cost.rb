class CreateScheduledCost < ActiveRecord::Migration
  def self.up
    create_table :scheduled_costs do |t|
      t.date :date
      t.money :cost
      t.string :city
      t.string :description
      t.timestamps
    end
  end
  def self.down
    drop_table :scheduled_costs
  end
end
