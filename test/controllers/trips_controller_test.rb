require "test_helper"

describe TripsController do
  let (:driver) {
    Driver.create!(
      name: "Lee H", 
      vin: "FJSKDJ12",
      available: true
    )
  }
  
  let (:passenger) {
    Passenger.create!(
      name: "Lak Mok",
      phone_num: "(555) 555-5555"
    )
  }

  let (:trip) {
    Trip.create!(
      driver_id: driver.id,
      passenger_id: passenger.id, 
      date: Date.today + 1, 
      cost: rand(1..5000),
      rating: nil,
    )
  }
  
  describe "show" do
    it "responds with success when showing an existing valid trip" do
      get trip_path(trip.id)
      must_respond_with :success
    end

    it "responds with 404 with an invalid trip id" do
      get trip_path(-1)
      must_respond_with :not_found
    end
  end

  describe "create" do
    it "can create a new trip with valid information accurately and redirect" do
      # Arrange
      driver.update(available: true) # make sure there is at least one available driver, otherwise test will have an error

      # Act-Assert
      expect {
        post passenger_trips_path(passenger.id)
      }.must_differ "Trip.count", 1

      # Assert
      new_trip = Trip.find_by(date: Date.today)
      expect(new_trip.passenger_id).must_equal passenger.id
      expect(new_trip.driver_id).must_equal driver.id
      expect(new_trip.date).must_equal Date.today
      expect(new_trip.cost).must_be_kind_of Float
      expect(new_trip.rating).must_be_nil
      
      must_redirect_to passenger_path(passenger.id)
    end

    it "sets driver status to unavailable upon successfully creating a new trip" do
      driver.update(available: true)

      expect {
        post passenger_trips_path(passenger.id)
      }.must_differ "Trip.count", 1

      driver.reload
      expect(driver.available).must_equal false
    end

    it "does not create a trip if an invalid passenger id is given, and responds with a 400 error" do
      driver.update(available: true)

      expect {
        post passenger_trips_path(-1)
      }.wont_differ "Trip.count"

      must_respond_with :bad_request
    end
  end

  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid trip" do
      get edit_trip_path(trip.id)
      must_respond_with :success
    end

    it "responds with a 400 error when getting the edit page for a non-existing trip" do
      get edit_trip_path(-1)
      must_respond_with :not_found
    end
  end

  describe "update" do
    let (:edited_trip_hash) {
      {
        trip: {
          date: Date.today + 2,
          rating: 5, 
          cost: 768
        },
      }
    }

    it "can update an existing trip with valid information accurately, and redirect" do
      id = trip.id

      expect {
        patch trip_path(id), params: edited_trip_hash
      }.wont_differ "Trip.count"

      trip.reload
      expect(trip.date).must_equal edited_trip_hash[:trip][:date]
      expect(trip.cost).must_equal edited_trip_hash[:trip][:cost]
      expect(trip.rating).must_equal edited_trip_hash[:trip][:rating]

      must_redirect_to passenger_path(trip.passenger.id)
    end

    it "does not update a trip if an invalid passenger id is given, and responds with a 404 error" do
      id = -1

      expect {
        patch trip_path(id), params: edited_trip_hash
      }.wont_differ "Trip.count"

      must_respond_with :not_found
    end
  end

  describe "destroy" do
    it "destroys the trip instance in db when trip exists, then redirects" do
      id = trip.id
      
      expect{
        delete trip_path(id)
      }.must_differ "Trip.count", -1

      must_redirect_to passenger_path(trip.passenger.id)
    end

    it "does not change the db when the trip does not exist, then responds with a 404 error" do
      id = -1

      expect{
        delete trip_path(id)
      }.wont_differ "Trip.count"

      must_respond_with :not_found
    end
  end
end
