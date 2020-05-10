require "test_helper"

describe Trip do
  let (:driver) {
    Driver.create(
      name: "Lee H", 
      vin: "FJSKDJ12",
      available: false
    )
  }
  
  let (:passenger) {
    Passenger.create(
      name: "Lak Mok",
      phone_num: "(555) 555-5555"
    )
  }

  let (:new_trip) {
    Trip.create(
      driver_id: driver.id,
      passenger_id: passenger.id, 
      date: Date.today, 
      cost: rand(1..5000),
      rating: nil,
    )
  }

  it "can be instantiated" do
    expect(new_trip.valid?).must_equal true
  end

  it "will have the required fields" do
    new_trip.save
    trip = Trip.first
    [:driver_id, :passenger_id, :date, :cost, :rating].each do |field|

      # Assert
      expect(trip).must_respond_to field
  end
end

  describe "relationships" do
    it "trip can link to only one driver and passenger" do
      # Arrange
      new_trip.save
      
      # Assert
      expect(new_trip.driver.count).must_equal 1
      expect(new_trip.passenger.count).must_equal 1
   
    end
  end

  describe "validations" do
    # Your tests go here
  end

  # Tests for methods you create should go here
  describe "custom methods" do
    # Your tests here
  end
end
