class PassengersController < ApplicationController
  def index
    @passengers = Passenger.paginate(page: params[:page]).order("id")
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

    @passenger.save ? (redirect_to passenger_path(@passenger)) : (render :new, status: :bad_request)
    return
  end

  def edit
    @passenger = Passenger.find_by(id: params[:id])
    redirect_to passengers_path if @passenger.nil?
    return
  end

  def update
    @passenger = Passenger.find_by(id: params[:id])
    
    if @passenger.nil?
      head :not_found
      return
    elsif @passenger.update(passenger_params)
      redirect_to passenger_path(@passenger)
      return
    else 
      render :edit, status: :bad_request
      return
    end
  end

  def destroy
    @passenger = Passenger.find_by(id: params[:id])
    
    if @passenger.nil?
      head :not_found
      return
    elsif Trip.where(passenger_id: @passenger.id).count > 0 # if the passenger has trips, we want to destroy them first; otherwise, the delete passenger button will cause an error
      Trip.where(passenger_id: @passenger.id).destroy_all
      @passenger.destroy
      redirect_to passengers_path
      return
    else
      @passenger.destroy
      redirect_to passengers_path
      return
    end
  end 

  private

  def passenger_params
    return params.require(:passenger).permit(:name, :phone_num)
  end
end
