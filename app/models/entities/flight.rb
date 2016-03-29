class Flight < ActiveRecord::Base
  belongs_to :plane_journey, inverse_of: :flights
  belongs_to :from, class_name: 'Airport'
  belongs_to :to, class_name: 'Airport'

  validates :plane_journey, presence: true
  validates :from, presence: true
  validates :to, presence: true
  validates :departure, presence: true
  validates :arrival, presence: true

  def departure_time_zone
    from.time_zone
  end

  def arrival_time_zone
    to.time_zone
  end

  def departure=(time)
    write_attribute :departure, ActiveSupport::TimeZone[departure_time_zone].parse(time)
  end

  def arrival=(time)
    write_attribute :arrival, ActiveSupport::TimeZone[arrival_time_zone].parse(time)
  end

  def departure
    read_attribute(:departure).in_time_zone(departure_time_zone)
  end

  def arrival
    read_attribute(:arrival).in_time_zone(arrival_time_zone)
  end

  def from_city
    from.city
  end

  def to_city
    to.city
  end
end
