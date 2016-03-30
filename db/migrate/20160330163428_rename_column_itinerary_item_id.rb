class RenameColumnItineraryItemId < ActiveRecord::Migration
  def change
    %w(snacks park_tickets meals transportations hotel_reservations guide_drivers).each do |table|
      rename_column table.to_sym, :itinerary_items_id, :itinerary_item_id
      # Reset the column information of each model
      table.singularize.camelize.constantize.reset_column_information
    end
  end
end
