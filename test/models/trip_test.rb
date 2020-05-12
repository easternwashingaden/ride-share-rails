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
      expect(new_trip.driver_id).must_equal driver.id
      expect(new_trip.passenger_id).must_equal passenger.id
   
    end
  end

  describe "validations" do
    it "must have a driver" do
      # Arrange
      new_trip.driver_id = nil

      # Assert
      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :driver_id
      expect(new_trip.errors.messages[:driver_id]).must_equal ["can't be blank"]
    end

    it "must have a passenger" do
      # Arrange
      new_trip.passenger_id = nil

      # Assert
      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :passenger_id
      expect(new_trip.errors.messages[:passenger_id]).must_equal ["can't be blank"]
    end

    it "must have a date" do
      # Arrange
      new_trip.date = nil

      # Assert
      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :date
      expect(new_trip.errors.messages[:date]).must_equal ["can't be blank"]
    end

    it "must have a cost " do
      # Arrange
      new_trip.cost = nil

      # Assert
      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :cost
      expect(new_trip.errors.messages[:cost]).must_equal ["can't be blank", "is not a number"]
    end

    it "The cost must be an integer " do
      # Arrange
      new_trip.cost = "ldaksfdlaksf1233"

      # Assert
      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :cost
      expect(new_trip.errors.messages[:cost]).must_equal ["is not a number"]

    end

    it "rating is an optional field " do
      # Arrange
      new_trip.rating = nil

      # Assert
      expect(new_trip.valid?).must_equal true
      expect(new_trip.errors.messages).wont_include :rating
      expect(new_trip.errors.messages[:rating]).must_equal []
    end
  end

  # Tests for methods you create should go here
  describe "custom methods" do
    # Your tests here
  end
end
