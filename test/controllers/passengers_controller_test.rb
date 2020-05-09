require "test_helper"

describe PassengersController do
  let (:passenger) {
    Passenger.create(
      name: "Lak Mok",
      phone_num: "(555) 555-5555"
    )
  }

  describe "index" do
    it "responds with success when there are many passengers saved" do
      get passengers_path
      must_respond_with :success
    end

    it "responds with success when there are no passengers saved" do
      passenger.destroy

      get passengers_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid passenger" do
      get passenger_path(passenger.id)
      must_respond_with :success
    end

    it "responds with redirect with an invalid passenger id" do
      get passenger_path("taco")
      must_redirect_to passengers_path
    end
  end

  describe "new" do
    it "responds with success" do
      get new_passenger_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new passenger with valid information accurately, and redirect" do
      # Arrange
      passenger_hash = {
        passenger: {
          name: "Lee H",
          phone_num: "(666) 666-6666"
        },
      }

      # Act-Assert
      expect {
        post passengers_path, params: passenger_hash
      }.must_differ "Passenger.count", 1

      # Assert
      new_passenger = Passenger.find_by(name: passenger_hash[:passenger][:name])
      expect(new_passenger.name).must_equal passenger_hash[:passenger][:name]
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
    it "responds with success when getting the edit page for an existing, valid passenger" do
      get edit_passenger_path(passenger.id)
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing passenger" do
      get edit_passenger_path("taco")
      must_redirect_to passengers_path
    end
  end

  describe "update" do
    let (:edited_passenger_hash) {
      {
        passenger: {
          name: "Lee H",
          phone_num: "(666) 666-6666"
        },
      }
    }

    it "can update an existing passenger with valid information accurately, and redirect" do
      id = passenger.id

      expect {
        patch passenger_path(id), params: edited_passenger_hash
      }.wont_differ "Passenger.count"

      passenger.reload
      expect(passenger.name).must_equal edited_passenger_hash[:passenger][:name]
      expect(passenger.phone_num).must_equal edited_passenger_hash[:passenger][:phone_num]

      must_redirect_to passenger_path(id)
    end

    it "does not update any passenger if given an invalid id, and responds with a 404" do
      id = "taco"

      expect {
        patch passenger_path(id), params: edited_passenger_hash
      }.wont_differ "Passenger.count"

      must_respond_with :not_found
    end

    it "does not create a passenger if the form data violates passenger validations, and responds with a 400 error" do
      id = passenger.id

      invalid_passenger_hash = {
        passenger: {
          name: "Lee H",
          phone_num: nil
        },
      }

      expect {
        patch passenger_path(id), params: invalid_passenger_hash
      }.wont_differ "Passenger.count"

      must_respond_with :bad_request
    end
  end

  describe "destroy" do
    it "destroys the passenger instance in db when passenger exists, then redirects" do
      id = passenger.id
      
      expect{
        delete passenger_path(id)
      }.must_differ "Passenger.count", 1

      must_redirect_to passengers_path
    end

    it "does not change the db when the passenger does not exist, then responds with a 404 error" do
      id = "taco"

      expect{
        delete passenger_path(id)
      }.wont_differ "Passenger.count"

      must_respond_with :not_found
    end
  end
end
