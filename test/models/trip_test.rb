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
    Trip.new(
      driver_id: driver.id,
      passenger_id: passenger.id, 
      date: Date.today, 
      cost: 1337,
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
      
      # Assert: This test was showing an error that there was no method "count" for new_trip.driver and new_trip.passenger, because the driver and passenger methods in the trip model return only one instance. When we changed "find_by" to "where" in the model methods, this test passed using "count," but the other relationships tests failed because "where" returns an ActiveRecord::Relation instance (array). We decided to use "find_by" in the methods and change this test to check if the return values are an instance of Driver and Passenger; otherwise, we'd have to use new_trip.driver.first to access any of the trip's driver attributes.
      expect(new_trip.driver).must_be_instance_of Driver
      expect(new_trip.passenger).must_be_instance_of Passenger
    end

    it 'can set the driver through "driver"' do
      new_driver = Driver.create!(name: "Waldo", vin: "ALWSS52P9NEYLVDE9", available: true)
      new_trip.driver = new_driver

      expect(new_trip.driver_id).must_equal new_driver.id
    end

    it 'can set the driver through "driver_id"' do
      new_driver = Driver.create!(name: "Waldo", vin: "ALWSS52P9NEYLVDE9", available: true)
      new_trip.driver_id = new_driver.id

      expect(new_trip.driver).must_equal new_driver
    end

    it 'can set the passenger through "passenger"' do
      new_passenger = Passenger.create!(name: "Kari", phone_num: "111-111-1211")
      new_trip.passenger = new_passenger

      expect(new_trip.passenger_id).must_equal new_passenger.id
    end

    it 'can set the passenger through "passenger_id"' do
      new_passenger = Passenger.create!(name: "Kari", phone_num: "111-111-1211")
      new_trip.passenger_id = new_passenger.id

      expect(new_trip.passenger).must_equal new_passenger
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

    it "must have a cost" do
      # Arrange
      new_trip.cost = nil

      # Assert
      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :cost
      expect(new_trip.errors.messages[:cost]).must_equal ["can't be blank", "is not a number"]
    end

    it "will only allow a number for cost" do
      # Arrange
      new_trip.cost = "ldaksfdlaksf1233"

      # Assert
      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :cost
      expect(new_trip.errors.messages[:cost]).must_equal ["is not a number"]
    end

    it "allows rating to be an optional field" do
      # Arrange
      new_trip.rating = nil

      # Assert
      expect(new_trip.valid?).must_equal true
      expect(new_trip.errors.messages).wont_include :rating
      expect(new_trip.errors.messages[:rating]).must_equal []
    end

    it "will only allow the user to set rating to 1-5" do
      new_trip.rating = 6

      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :rating
      expect(new_trip.errors.messages[:rating]).must_equal ["is not included in the list"]
    end
  end

  # Tests for methods you create should go here
  describe "cost to currency" do
    it "can successfully convert trip cost to a currency string" do
      new_trip.save
      expect(new_trip.cost_to_currency).must_equal "$1,337.00"
    end
  end
end
