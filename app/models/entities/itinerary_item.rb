class ItineraryItem < ActiveRecord::Base
  serialize :subscribed_users, Set
  belongs_to  :itinerary
  acts_as_commentable
  uses_comment_extensions
  acts_as_taggable_on :tags
  has_many :meals
  has_many :snacks
  has_many :hotel_reservations
  has_many :transportations
  has_many :guide_drivers
  has_many :park_tickets
  has_paper_trail class_name: 'Version', ignore: [:subscribed_users]
  has_fields
  exportable
  sortable by: ["order_date ASC", "created_at DESC", "updated_at DESC"], default: "created_at DESC"
end
