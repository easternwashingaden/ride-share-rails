class PassengersController < ApplicationController
  def index
    @passengers = Passenger.order("id")
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end 
end
