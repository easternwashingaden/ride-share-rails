require "test_helper"

describe Passenger do
  let (:new_passenger) {
    Passenger.new(name: "Kari", phone_num: "111-111-1211")
  }

  it "can be instantiated" do
    # Assert
    expect(new_passenger.valid?).must_equal true
  end

  it "will have the required fields" do
    # Arrange
    new_passenger.save
    passenger = Passenger.first
    [:name, :phone_num].each do |field|

      # Assert
      expect(passenger).must_respond_to field
    end
  end

  describe "relationships" do
    it "can have many trips" do
      # Arrange
      new_passenger.save
      new_driver = Driver.create!(name: "Waldo", vin: "ALWSS52P9NEYLVDE9", available: true)
      trip_1 = Trip.create!(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1234)
      trip_2 = Trip.create!(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 6334)
      
      # Assert
      expect(new_passenger.trips.count).must_equal 2
      new_passenger.trips.each do |trip|
        expect(trip).must_be_instance_of Trip
      end
    end
  end

  describe "validations" do
    it "must have a name" do
      # Arrange
      new_passenger.name = nil

      # Assert
      expect(new_passenger.valid?).must_equal false
      expect(new_passenger.errors.messages).must_include :name
      expect(new_passenger.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "must have a phone number" do
      # Arrange
      new_passenger.phone_num = nil

      # Assert
      expect(new_passenger.valid?).must_equal false
      expect(new_passenger.errors.messages).must_include :phone_num
      expect(new_passenger.errors.messages[:phone_num]).must_equal ["can't be blank"]
    end
  end

  # Tests for methods you create should go here
  describe "request a ride" do
    it "can set the passenger for a new trip through passenger_id" do 
      new_passenger.save
      new_driver = Driver.create!(name: "Waldo", vin: "ALWSS52P9NEYLVDE9", available: true)
      new_trip = Trip.new(driver_id: new_driver.id, passenger_id: nil, date: Date.today, rating: nil, cost: 1337)

      new_trip.passenger_id = new_passenger.id

      expect { new_trip.save }.must_differ "Trip.count", 1
      expect(new_trip.passenger_id).must_equal new_passenger.id
    end
  end

  describe "complete trip" do
    # We could not find a way to patch an existing trip from the model test (the terminal kept showing a NameError for patch trip_path(new_trip.id)). Instead, the following test checks whether rating can be assigned to a new trip that has not been saved.
    it "can successfully assign a rating to a trip" do
      new_passenger.save
      new_driver = Driver.create!(name: "Waldo", vin: "ALWSS52P9NEYLVDE9", available: true)
      new_trip = Trip.new(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: nil, cost: 1337)
      
      new_trip.rating = 5

      expect { new_trip.save }.must_differ "Trip.count", 1
      expect(new_trip.rating).must_equal 5
    end
  end
  
  describe "total charges" do
    it "will return the total cost of all trips taken by the passenger" do
      new_passenger.save
      new_driver = Driver.create!(name: "Waldo", vin: "ALWSS52P9NEYLVDE9", available: true)
      trip_1 = Trip.create!(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 337)
      trip_2 = Trip.create!(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 1000)
      
      expect(new_passenger.total_charges).must_equal 1337.0
    end

    it "will return zero if the passenger has no trips" do
      new_passenger.save

      expect(new_passenger.trips.count).must_equal 0
      expect(new_passenger.total_charges).must_equal 0
    end
  end
end