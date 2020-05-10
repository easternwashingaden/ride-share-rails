require "test_helper"

describe TripsController do
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

  let (:trip) {
    Trip.create(
      driver_id: driver.id,
      passenger_id: passenger.id, 
      date: Date.today, 
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
    let (:new_driver) {
      Driver.create(
        name: "new driver", 
        vin: "FJSKDJ12",
        available: true
      )
    }

    it "can create a new trip with valid information accurately, and redirect" do
      # Arrange
      trip_hash = {
        trip: {
          driver_id: new_driver.id,
          passenger_id: passenger.id,
          date: Time.new,
          rating: nil, 
          cost: 240
        },
      }

      # Act-Assert
      expect {
        post trips_path, params: trip_hash
      }.must_differ "Trip.count", 1

      # Assert
      new_trip = Trip.find_by(name: trip_hash[:trip][:driver_id])
      expect(new_trip.name).must_equal passenger_hash[:passenger][:name]
      expect(new_passenger.phone_num).must_equal passenger_hash[:passenger][:phone_num]
      
      must_redirect_to passenger_path(new_passenger.id)
    end

    it "does not create a passenger if the form data violates passenger validations, and responds with a 400 error" do
      # Arrange
      invalid_passenger_hash = {
        passenger: {
          name: "Lee H",
          phone_num: nil
        },
      }

      # Act-Assert
      expect {
        post passengers_path, params: invalid_passenger_hash
      }.wont_differ "Passenger.count"

      # Assert
      must_respond_with :bad_request
    end
  end

  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid " do
      get edit_trip_path(trip.id)
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing trip" do
      get edit_trip_path(-1)
      must_redirect_to edit_trip_path
    end
  end

  describe "update" do
    let (:edited_trip_hash) {
      {
        trip: {
          date: Date.today,
          rating: 5, 
          cost: 768
        },
      }
    }

    it "can update an existing trip with valid information accurately, and redirect" do
      id = trip.id
      expect {
        patch trip_path(id), params: edited_trip_hash
      }.wont_differ "Trip.where(passenger_id: passenger.id).count"

      passenger.reload
      expect(trip.date).must_equal edited_trip_hash[:trip][:date]
      expect(trip.cost).must_equal edited_trip_hash[:trip][:cost]
      expect(trip.rating).must_equal edited_trip_hash[:trip][:cost]

      must_redirect_to passenger_path(trip.passenger.id)
    end
  end

  describe "destroy" do
    it "destroys the trip instance in db when trip exists, then redirects" do
      id = trip.id
      
      expect{
        delete trip_path(id)
      }.must_differ "Trip.where(passenger_id: passenger.id).count", -1

      must_redirect_to passenger_path(trip.passenger.id)
    end

    it "does not change the db when the trip does not exist, then responds with a 404 error" do
      id = -1

      expect{
        delete trip_path(id)
      }.wont_differ "Trip.where(passenger_id: passenger.id).count"

      must_respond_with :not_found
    end
  end
end
