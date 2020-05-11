class Driver < ApplicationRecord
  has_many :trips
  validates :name, presence: true
  validates :vin, presence: true

  def get_total_earnings
    trips = Trip.where(driver_id: self.id)
    return trips.empty? ? 0 : (trips.map { |trip| trip.cost }.sum)
  end

end
