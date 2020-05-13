require "test_helper"

describe DriversController do
  let (:driver) {
    Driver.create!(
      name: "new driver", 
      vin: "FJSKDJ12",
      available: true
    )
  }

  describe "index" do
    it "responds with success when there are many drivers saved" do
      get drivers_path
      must_respond_with :success
    end

    it "responds with success when there are no drivers saved" do
      driver.destroy

      get drivers_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid driver" do
      get driver_path(driver.id)
      must_respond_with :success
    end

    it "responds with 404 with an invalid driver id" do
      get driver_path(-1)
      must_redirect_to drivers_path
    end
  end

  describe "new" do
    it "responds with success" do
      get new_driver_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new driver with valid information accurately, and redirect" do
      # Arrange 
      # "name" and "vin" are the only two params that will be passed in to the action
      driver_hash = {
        driver: {
          name: "new driver",
          vin: "BAJDKSH124"
        },
      } 

      # Act-Assert
      expect {
        post drivers_path, params: driver_hash
      }.must_change "Driver.count", 1
      
      # Assert
      new_driver = Driver.find_by(name: driver_hash[:driver][:name])
      expect(new_driver.name).must_equal driver_hash[:driver][:name]
      expect(new_driver.vin).must_equal driver_hash[:driver][:vin]
      expect(new_driver.available).must_equal true # new drivers are available by default
      
      must_redirect_to driver_path(new_driver.id) 
    end

    it "does not create a driver if the form data violates Driver validations, and responds with a 400 error" do
      invalid_driver_hash = {
        driver: {
          name: nil,
          vin: "KDJD124"
        }
      }
      # Act-Assert
      expect {
        post drivers_path, params: invalid_driver_hash
      }.wont_differ "Driver.count"

      # Assert
      must_respond_with :bad_request
    end
  end
  
  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid driver" do
      get edit_driver_path(driver.id)
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing driver" do
      get edit_driver_path(-1)
      must_redirect_to drivers_path
    end
  end

  describe "update" do
    # "name" and "vin" are the only two params that will be passed in to the action
    let (:edited_driver_hash) {
      {
        driver: {
          name: "Lee Lak",
          vin: "LDFKD34",
        }
      }
    }
    
    it "can update an existing driver with valid information accurately, and redirect" do
      id = driver.id

      expect{
        patch driver_path(id), params: edited_driver_hash
      }.must_differ "Driver.count", 0

      driver.reload
      expect(driver.name).must_equal edited_driver_hash[:driver][:name]
      expect(driver.vin).must_equal edited_driver_hash[:driver][:vin]
      expect(driver.available).must_equal true # we cannot change availability using the edit form

      must_redirect_to driver_path(id)
    end

    it "does not update any driver if given an invalid id, and responds with a 404" do
      expect{
        patch driver_path(-1), params: edited_driver_hash
      }.wont_change "Driver.count"

      must_respond_with :not_found
    end

    it "does not create a driver if the form data violates Driver validations, and responds with a 400 error" do
      id = driver.id

      invalid_driver_hash = {
        driver: {
          name: nil,
          vin: "LDFKDLF12",
        },
      }

      expect {
        patch driver_path(id), params: invalid_driver_hash
      }.wont_differ "Driver.count"

      must_respond_with :bad_request
    end
  end

  describe "destroy" do
    it "destroys the driver instance in db when driver exists and has no trips, then redirects" do
      id = driver.id

      expect {
        delete driver_path(id)
      }.must_differ "Driver.count", -1

      must_redirect_to drivers_path
    end

    it "destroys the driver instance in db when driver exists and has at least one trip, then redirects" do
      id = driver.id

      new_passenger = Passenger.create!(name: "Lee", phone_num: "(555) 555-5555")
      trip_1 = Trip.create!(driver_id: id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1234)
      trip_2 = Trip.create!(driver_id: id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 6334)
  
      expect {
        delete driver_path(id)
      }.must_differ "Driver.count", -1

      must_redirect_to drivers_path
    end

    it "does not change the db when the driver does not exist, then responds with a 400 error" do
      id = -1

      expect{
        delete driver_path(id)
      }.wont_differ "Driver.count"

      must_respond_with :not_found
    end
  end

  describe "toggle_available" do
    it "can change an available driver to unavailable, and redirect" do
      id = driver.id

      expect { 
        patch driver_available_path(id)
      }.wont_differ "Driver.count"

      driver.reload
      expect(driver.available).must_equal false
      
      must_redirect_to driver_path
    end

    it "can change an unavailable driver to available, and redirect" do
      id = driver.id
      driver.update(available: false)

      expect { 
        patch driver_available_path(id)
      }.wont_differ "Driver.count"

      driver.reload
      expect(driver.available).must_equal true

      must_redirect_to driver_path
    end

    it "does not change driver status when the driver does not exist, then responds with a 400 error" do
      id = -1

      expect {
        patch driver_available_path(id)
      }.wont_change "Driver.count"
      
      must_respond_with :not_found
    end
  end
end

