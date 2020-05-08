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
    @passenger = Passenger.new(passenger_params)

    if @passenger.valid?
      @passenger.save ? (redirect_to passenger_path(@passenger)) : (render :new)
      return
    else 
      head :bad_request
      return 
    end
  end

  def edit
    @passenger = Passenger.find_by(id: params[:id])
    redirect_to passengers_path if @passenger.nil?
    return
  end

  def update
  end

  def destroy
  end 

  private

  def passenger_params
    return params.require(:passenger).permit(:name, :phone_num)
  end
end
