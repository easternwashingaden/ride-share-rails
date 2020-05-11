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
  end

  # Tests for methods you create should go here
  describe "total_earnings" do
    it " The total earnings should be 0 if the driver doesn't have any trip" do
      # Arrange 
      # No trip is created

      # Assert 
      expect(new_driver.get_total_earnings).must_equal 0
    end

    it " The total earnings should be sum of all trips that the driver gets 80% of the trip cost after a fee of $1.65" do
      # Arrange
      new_driver.save
      new_passenger.save
      trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 250)
      trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 100)
      trip_3 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 1, cost: 168)
      
      trips = Trip.where(driver_id: new_driver.id)
      
      # Assert
      expect(trips.count).must_equal 3
      expect(new_driver.get_total_earnings).must_equal 410.44.to_s
    end

    describe "average_rating" do
      it " The average rating should be 0 if the driver doesn't have any trip" do
        # Arrange 
        # No trip is created
  
        # Assert 
        expect(new_driver.average_rating).must_equal 0
      end
  
      it "The average rating should be sum of all ratings divided by the number of ratings" do
        # Arrange
        new_driver.save
        new_passenger.save
        trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 250)
        trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 100)
        trip_3 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 2, cost: 168)
        
        trips = Trip.where(driver_id: new_driver.id)
        
        # Assert
        expect(trips.count).must_equal 3
        expect(new_driver.average_rating).must_equal "3.00"
      end
    end

    describe "can go online" do
      # Your code here
    end

    describe "can go offline" do
      # Your code here
    end

    # You may have additional methods to test
  end
end
