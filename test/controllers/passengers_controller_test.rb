require "test_helper"

describe PassengersController do
  describe "index" do
    before do
      @passenger = Passenger.create(
        name: "Lak Mok",
        phone_num: "(555) 555-5555"
      )
    end

    it "responds with success when there are many passengers saved" do
      get passengers_path
      must_respond_with :success
    end

    it "responds with success when there are no passengers saved" do
      @passenger.destroy

      get passengers_path
      must_respond_with :success
    end
  end

  describe "show" do
    # Your tests go here
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
