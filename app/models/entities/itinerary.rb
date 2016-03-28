class Itinerary < ActiveRecord::Base
  has_many :itinerary_item
end
