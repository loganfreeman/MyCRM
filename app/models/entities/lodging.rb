class Lodging < ActiveRecord::Base

  validates :name, presence: true, uniqueness: {scope: :city}
  validates :city, presence: true

  def self.ordered
    order(:city, :name)
  end

  def to_s
    "#{city}: #{name}"
  end

end
