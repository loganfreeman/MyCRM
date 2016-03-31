class GuideDriver < ActiveRecord::Base
  belongs_to :itinerary_item
  acts_as_taggable_on :tags
  acts_as_commentable
  has_paper_trail class_name: 'Version', ignore: [:subscribed_users]
  has_fields
  exportable
  sortable by: ["created_at DESC", "updated_at DESC"], default: "created_at DESC"
end
