class Stay < ActiveRecord::Base
  belongs_to :lodging

  monetize :cost_subunits, with_model_currency: :cost_currency, allow_nil: true, numericality: {greater_than_or_equal_to: 0}

  validates :lodging, presence: true
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :validate_nonoverlapping

  accepts_nested_attributes_for :lodging

  def self.chronological
    order(:checkin)
  end

  def self.present_and_future
    where('stays.checkout >= ?', Date.today)
  end

  def self.unpaid
    where paid: false
  end

  def payment_event
    [checkin, cost]
  end

  def nights
    (checkout - checkin).to_i
  end

  def has_laundry?
    lodging.has_laundry?
  end

  def has_kitchen?
    lodging.has_kitchen?
  end

  def overlapping_stays
    # This method obviously doesn't work right if checkin or checkout is missing.
    # It also doesn't work if the caller is persisted.
    Stay.where('? > checkin and checkout > ?', checkin, checkout)
  end

  def validate_nonoverlapping
    return unless checkin && checkout
    if overlapping_stays.exists?
      errors.add(:checkin, 'cannot overlap another stay')
      errors.add(:checkout, '')
    end
  end
end
