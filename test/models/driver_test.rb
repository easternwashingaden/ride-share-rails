require "test_helper"

describe Driver do
  let (:new_driver) {
    Driver.new(name: "Kari", vin: "123", available: true)
  }
  let (:new_passenger) {
    Passenger.new(name: "Kari", phone_num: "111-111-1211")
  }
  it "can be instantiated" do
    # Assert
    expect(new_driver.valid?).must_equal true
  end

  it "will have the required fields" do
    # Arrange
    new_driver.save
    driver = Driver.first
    [:name, :vin, :available].each do |field|

      # Assert
      expect(driver).must_respond_to field
    end
  end

  describe "relationships" do
    it "can have many trips" do
      # Arrange
      new_driver.save
      new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
      trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1234)
      trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 6334)
      
      # Assert
      expect(new_driver.trips.count).must_equal 2
      new_driver.trips.each do |trip|
        expect(trip).must_be_instance_of Trip
      end
    end
  end

  describe "validations" do
    it "must have a name" do
      # Arrange
      new_driver.name = nil

      # Assert
      expect(new_driver.valid?).must_equal false
      expect(new_driver.errors.messages).must_include :name
      expect(new_driver.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "must have a VIN number" do
      # Arrange
      new_driver.vin = nil

      # Assert
      expect(new_driver.valid?).must_equal false
      expect(new_driver.errors.messages).must_include :vin
      expect(new_driver.errors.messages[:vin]).must_equal ["can't be blank"]
    end

    it "will only allow true or false for available" do
      new_driver.available = nil

      expect(new_driver.valid?).must_equal false
      expect(new_driver.errors.messages).must_include :available
      expect(new_driver.errors.messages[:available]).must_equal ["is not included in the list"]
    end
   end

  # Tests for methods you create should go here
  describe "total_earnings" do
    it "returns 0 if the driver doesn't have any trips" do
      # Arrange 
      new_driver.save

      # Assert 
      expect(new_driver.get_total_earnings).must_equal 0
    end

    it "accurately calculates total earnings if the driver has trips (80% of the trip cost after a fee of $1.65)" do
      # Arrange
      new_driver.save
      new_passenger.save
      trip_1 = Trip.create!(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 251.65)
      trip_2 = Trip.create!(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 101.65)
      trip_3 = Trip.create!(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 1, cost: 151.65)
      
      trips = Trip.where(driver_id: new_driver.id)
    
      # Assert
      expect(trips.count).must_equal 3
      expect(new_driver.get_total_earnings).must_equal 400.0
    end

    describe "average_rating" do
      it "returns 0 if the driver doesn't have any trips" do
        # Arrange 
        new_driver.save
  
        # Assert 
        expect(new_driver.average_rating).must_equal 0
      end
  
      it "accurately calculates average rating if the driver has trips" do
        # Arrange
        new_driver.save
        new_passenger.save
        trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 250)
        trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 100)
        trip_3 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 1, cost: 150)
        
        trips = Trip.where(driver_id: new_driver.id)
        
        # Assert
        expect(trips.count).must_equal 3
        expect(new_driver.average_rating).must_equal 3.0
      end
    end

    describe "available" do
      it "can go online" do
        new_driver.available = true
        expect { new_driver.save }.must_differ "Driver.count", 1
        expect(new_driver.available).must_equal true
      end

      it "can go offline" do
        new_driver.available = false
        expect { new_driver.save }.must_differ "Driver.count", 1
        expect(new_driver.available).must_equal false
      end
    end
  end
end
