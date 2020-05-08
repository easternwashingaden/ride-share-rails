class PassengersController < ApplicationController
  def index
    @passengers = Passenger.order("id")
  end

  def show
    @passenger = Passenger.find_by(id: params[:id])
    redirect_to passengers_path if @passenger.nil?
    return
  end

  def new
    @passenger = Passenger.new
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
