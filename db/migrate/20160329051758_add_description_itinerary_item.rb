class AddDescriptionItineraryItem < ActiveRecord::Migration
  def change
    unless column_exists? :itinerary_items, :description
      add_column :itinerary_items, :description, :string
    end
  end
end
