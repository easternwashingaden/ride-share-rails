class Driver < ApplicationRecord
  has_many :trips
  
  validates :name, presence: true
  validates :vin, presence: true
  validates :available, inclusion: { in: [true, false] }
end
