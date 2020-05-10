class TripsController < ApplicationController
  
  def show
    @trip = Trip.find_by(id: params[:id])
    head :not_found if @trip.nil?
    return
  end

  def create
    driver = Driver.find_by(available: true)
    @trip = Trip.new(
      passenger_id: params[:id],
      driver_id: driver.id,
      date: Date.today,
      cost: rand(1..5000), # set cost to random number
      rating: nil # set rating to nil
    )
    if @trip.save
      # flash[:success] = "Trip added successfully"
      redirect_to passenger_path
      driver.update(available: false)
      return
    else
      # flash.now[:error] = "Something went wrong. Trip not added"
      redirect_to passenger_path(params[:id]), status: :bad_request
      return
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end 

  private 

  def trip_params
    return params.require(:trip).permit(:date, :cost, :rating)
  end
end
