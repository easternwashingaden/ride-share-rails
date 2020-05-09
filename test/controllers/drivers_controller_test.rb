require "test_helper"

describe DriversController do
  # Note: If any of these tests have names that conflict with either the requirements or your team's decisions, feel empowered to change the test names. For example, if a given test name says "responds with 404" but your team's decision is to respond with redirect, please change the test name.
  let (:driver) {
    Driver.create(
      name: " new driver", 
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
      # Driver.destroy_all
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
      must_respond_with :not_found # Here, we can either redirect or show a sucess message
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
      # Set up the form data
      driver_hash = {
        driver: {
          name: "new driver",
          vin: "BAJDKSH124",
          available: true
        },
      }

      # Act-Assert
      # Ensure that there is a change of 1 in Driver.count
      expect {
        post drivers_path, params: driver_hash
      }.must_change "Driver.count", 1
      # Assert
      # Find the newly created Driver, and check that all its attributes match what was given in the form data
      
      new_driver = Driver.find_by(name: driver_hash[:driver][:name])
      expect(new_driver.name).must_equal driver_hash[:driver][:name]
      expect(new_driver.vin).must_equal driver_hash[:driver][:vin]
      expect(new_driver.available).must_equal driver_hash[:driver][:available]
      
      # Check that the controller redirected the user
      must_redirect_to driver_path(new_driver.id) 
    end

    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Set up the form data so that it violates Driver validations
      invalid_driver_hash = {
        driver: {
          name: nil,
          vin: "KDJD124",
          available: true
        }
      }
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        post drivers_path, params: invalid_driver_hash
      }.wont_differ "Driver.count"

      # Assert
      # Check that the controller redirects
      must_respond_with :bad_request
    end
  end
  
  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid driver" do
      get edit_driver_path(driver.id)
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing driver" do
      # Arrange
      # Ensure there is an invalid id that points to no driver
      get edit_driver_path(-1)
      must_redirect_to drivers_path
    end
  end

  describe "update" do
    before do
      Driver.create(name: "new driver", vin: "FLDKDJ123", available: true)
      @params_hash = {
        driver: {
          name: "Lee Lak",
          vin: "LDFKD34",
          available: true
        }
      }
    end
    it "can update an existing driver with valid information accurately, and redirect" do
      updated_driver = Driver.first
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect{
        patch driver_path(updated_driver.id), params: @params_hash
      }.must_differ "Driver.count", 0

      updated_driver.reload
      expect(Driver.first.name).must_equal @params_hash[:driver][:name]
      expect(Driver.first.vin).must_equal @params_hash[:driver][:vin]
      expect(Driver.first.available).must_equal @params_hash[:driver][:available]
      # Check that the controller redirected the user
      must_redirect_to driver_path(updated_driver.id)
    end

    it "does not update any driver if given an invalid id, and responds with a 404" do
      expect{
        patch driver_path(-1), params: @params_hash
      }.wont_change "Driver.count"
      must_respond_with :not_found
    end

    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      updated_driver = Driver.first

      invalid_driver_hash = {
        driver: {
          name: "Lee H",
          vin: "LDFKDLF12",
          available: true
        },
      }

      expect {
        patch driver_path(updated_driver.id), params: invalid_driver_hash
      }.wont_differ "Driver.count"

      must_respond_with :bad_request
    end
  end

  describe "destroy" do
    before do
      Driver.create(name: "new driver", vin: "LKFDKJD12", available: true)
    end
    it "destroys the driver instance in db when driver exists, then redirects" do
      driver1 = Driver.first
      expect {
        delete driver_path(driver1.id)
      }.must_differ "Driver.count", -1

      must_redirect_to Drivers_path
    end

    it "does not change the db when the driver does not exist, then responds with " do
      # Arrange
      # Ensure there is an invalid id that points to no driver
      id = -1
      expect{
        delete driver_path(id)
      }.wont_differ "Driver.count"

      must_respond_with :not_found
    end
  end
end

