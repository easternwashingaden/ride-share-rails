include ActionView::Helpers::NumberHelper

class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  validates :driver_id, :passenger_id, :date, :cost, presence: true
  validates :rating, inclusion: { in: [1, 2, 3, 4, 5] }
  validates :cost, numericality: true

  def driver
    return Driver.find_by(id: self.driver_id)
  end

  def passenger
    return Passenger.find_by(id: self.passenger_id)
  end

  def cost_to_currency
    return number_to_currency(self.cost)
  end
end
