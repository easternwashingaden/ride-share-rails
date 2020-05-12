include ActionView::Helpers::NumberHelper

class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  validates :driver_id, :passenger_id, :date, :cost, presence: true
  validates :rating, :inclusion => {:in => [nil, 1, 2, 3, 4, 5]}
  validates :cost, numericality: { only_integer: true }

  def cost_to_currency
    return number_to_currency(self.cost)
  end
end
