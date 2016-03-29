class PlaneJourney < ActiveRecord::Base
  has_many :flights, ->{order :departure}, dependent: :destroy, inverse_of: :plane_journey

  monetize :cost_subunits, with_model_currency: :cost_currency, allow_nil: true, numericality: {greater_than_or_equal_to: 0}

  accepts_nested_attributes_for :flights, reject_if: :all_blank, allow_destroy: true

  def self.unpaid
    unbooked
  end

  def self.unbooked
    where booked: false
  end

  def self.paid
    booked
  end

  def self.booked
    where booked: true
  end

  def payment_event
    [departure, cost]
  end

  def paid?
    booked?
  end

  def from_city
    return nil if flights.empty?
    flights.first.from_city
  end

  def to_city
    return nil if flights.empty?
    flights.last.to_city
  end

  def departure
    return nil if flights.empty?
    flights.first.departure
  end

  def arrival
    return nil if flights.empty?
    flights.last.arrival
  end
end
