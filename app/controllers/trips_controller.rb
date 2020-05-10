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
    @trip = Trip.find_by(id: params[:id])
    
    if @trip.nil?
      redirect_to edit_trip_path
      return
    end
  end

  def update
    @trip = Trip.find_by(id: params[:id])
    
    if @trip.nil?
      head :not_found
      return
    elsif @trip.update(trip_params)
      redirect_to passenger_path(@trip.passenger.id)
      return
    else 
      render :edit, status: :bad_request
      return
    end
  end

  def destroy
    @trip = Trip.find_by(id: params[:id])
    
    if @trip.nil?
      head :not_found
      return
    else
      @trip.destroy
      redirect_to passenger_path(@trip.passenger.id)
      return
    end
  end 

  private 

  def trip_params
    return params.require(:trip).permit(:passenger_id, :driver_id, :date, :cost, :rating)
  end
end
