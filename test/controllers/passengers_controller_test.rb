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
    # Your tests go here
  end

  describe "create" do
    # Your tests go here
  end

  describe "edit" do
    # Your tests go here
  end

  describe "update" do
    # Your tests go here
  end

  describe "destroy" do
    # Your tests go here
  end
end
