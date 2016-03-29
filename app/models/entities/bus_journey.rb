class BusJourney < ActiveRecord::Base

  validates :from, presence: true
  validates :to, presence: true
  validates :date, presence: true

  monetize :cost_subunits, with_model_currency: :cost_currency, allow_nil: true, numericality: {greater_than_or_equal_to: 0}

  def self.present_and_future
    where('date >= ?', Date.today)
  end

  def self.chronological
    order(:date)
  end

  def self.unpaid
    unbooked
  end

  def self.unbooked
    where booked: false
  end

  def payment_event
    [date, cost]
  end

  def paid?
    booked?
  end
end
