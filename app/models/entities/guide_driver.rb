class GuideDriver < ActiveRecord::Base
  belongs_to :itinerary_item
  acts_as_taggable_on :tags
  acts_as_commentable
  has_paper_trail class_name: 'Version', ignore: [:subscribed_users]
  has_fields
  exportable
  sortable by: ["created_at DESC", "updated_at DESC"], default: "created_at DESC"
  def guide_contact
    if guide.present?
      Contact.find_by_id(guide)
    else
      Contact.new
    end
  end

  def driver_contact
    if driver.present?
      Contact.find_by_id(driver)
    else
      Contact.new
    end
  end
end
