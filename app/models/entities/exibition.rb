class Exibition < ActiveRecord::Base
  belongs_to :user
  belongs_to :assignee, class_name: "User", foreign_key: :assigned_to
  serialize :subscribed_users, Set
  uses_user_permissions
  acts_as_commentable
  uses_comment_extensions
  acts_as_taggable_on :tags
  has_paper_trail class_name: 'Version', ignore: [:subscribed_users]
  has_fields
  exportable

  scope :state, ->(filters) {
    where('status IN (?)' + (filters.delete('other') ? ' OR status IS NULL' : ''), filters)
  }
  scope :created_by,  ->(user) { where(user_id: user.id) }
  scope :assigned_to, ->(user) { where(assigned_to: user.id) }

  sortable by: ["name ASC", "starts_on DESC", "ends_on DESC", "created_at DESC", "updated_at DESC"], default: "created_at DESC"


  validates_presence_of :name, message: :missing_exibition_name
  validates_uniqueness_of :name, scope: [:user_id, :deleted_at]
  validate :start_and_end_dates

  # Make sure end date > start date.
  #----------------------------------------------------------------------------
  def start_and_end_dates
    if (starts_on && ends_on) && (starts_on > ends_on)
      errors.add(:ends_on, :dates_not_in_sequence)
    end
  end

  ActiveSupport.run_load_hooks(:fat_free_crm_exibition, self)
end
