class PlanyJourneyBelongsToItinerary < ActiveRecord::Migration
  def change
    add_reference :plane_journeys, :itinerary, index: true
  end
end
