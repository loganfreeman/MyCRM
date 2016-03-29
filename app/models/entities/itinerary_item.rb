class ItineraryItem < ActiveRecord::Base
  belongs_to  :itinerary
  acts_as_commentable
  uses_comment_extensions
  acts_as_taggable_on :tags
  has_paper_trail class_name: 'Version', ignore: [:subscribed_users]
  has_fields
  exportable
  sortable by: ["order_date ASC", "created_at DESC", "updated_at DESC"], default: "created_at DESC"
end
