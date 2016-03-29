class ScheduledCost < ActiveRecord::Base
  monetize :cost_subunits, with_model_currency: :cost_currency, allow_nil: false

  validates :date, presence: true
  validates :city, presence: true
  validates :description, presence: true

  def self.chronological
    order(:date)
  end

  def self.present_and_future
    where('date >= ?', Date.today)
  end

  def payment_event
    [date, cost]
  end
end
