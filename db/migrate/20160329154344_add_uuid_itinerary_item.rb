class AddUuidItineraryItem < ActiveRecord::Migration
  def change
    unless column_exists? :itinerary_items, :uuid
      add_column :itinerary_items, :uuid, :string, limit: 36
    end
    unless column_exists? :itinerary_items, :deleted_at
      add_column :itinerary_items, :deleted_at, :datetime
    end
  end
end
