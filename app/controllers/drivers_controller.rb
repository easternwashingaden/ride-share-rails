class DriversController < ApplicationController
  def index
    @drivers = Driver.all.order("id")
  end

  def show
    driver_id = params[:id]
    @driver = Driver.find_by(id: driver_id)
    if @driver.nil?
      head :not_found
      return
    end
  end

  def new
    @driver = Driver.new
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
