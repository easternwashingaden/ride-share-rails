class Driver < ApplicationRecord
  has_many :trips
  validates :name, presence: true
  validates :vin, presence: true

  def get_total_earnings
    trips = Trip.where(driver_id: self.id)
    '%.2f' % 
    return trips.empty? ? 0 : (trips.map { |trip| (trip.cost - 1.65)*0.8 }.sum)
  end

  def average_rating
    trips = Trip.where(driver_id: self.id)
    return trips.empty? ? 0 : (trips.map { |trip| trip.rating.to_i }.sum)/trips.length
  end
end
