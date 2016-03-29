class Itinerary < ActiveRecord::Base
  has_many :itinerary_items
  belongs_to :user
  belongs_to :account
  belongs_to :assignee, class_name: "User", foreign_key: :assigned_to
  has_many :addresses, dependent: :destroy, as: :addressable, class_name: "Address" # advanced search uses this
  has_many :emails, as: :mediator
  has_one :plane_journey

  serialize :subscribed_users, Set

  uses_user_permissions
  acts_as_commentable
  uses_comment_extensions
  acts_as_taggable_on :tags
  has_paper_trail class_name: 'Version', ignore: [:subscribed_users]
  has_fields
  exportable
  sortable by: ["name ASC", "created_at DESC", "updated_at DESC"], default: "created_at DESC"

  scope :visible_on_dashboard, ->(user) {
    # Show accounts which either belong to the user and are unassigned, or are assigned to the user
    where('(user_id = :user_id AND assigned_to IS NULL) OR assigned_to = :user_id', user_id: user.id)
  }

  scope :by_name, -> { order(:name) }
end
