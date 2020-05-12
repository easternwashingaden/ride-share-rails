class Passenger < ApplicationRecord
  has_many :trips
  validates :name, presence: true
  validates :phone_num, presence: true

  def total_charges
    trips = Trip.where(passenger_id: self.id)
    return trips.empty? ? 0 : trips.map { |trip| trip.cost }.sum
  end
end
