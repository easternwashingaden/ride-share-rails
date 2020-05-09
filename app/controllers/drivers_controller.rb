class DriversController < ApplicationController
  def index
    @drivers = Driver.order("id")
  end

  def show
    @driver = Driver.find_by(id: params[:id])

    if @driver.nil?
      redirect_to drivers_path
      return
    end
  end

  def new
    @driver = Driver.new
  end

  def create
    @driver = Driver.new(driver_params)
    @driver[:available] = true # new drivers are available by default
    
    if @driver.save
      # flash[:success] = "Driver added successfully"
      redirect_to driver_path(@driver)
      return
    else
      # flash.now[:error] = "Something went wrong. Driver not added"
      render :new, status: :bad_request
      return
    end
  end

  def edit
    @driver = Driver.find_by(id: params[:id])
    
    if @driver.nil?
      redirect_to drivers_path
      return
    end
  end

  def update
    @driver = Driver.find_by(id: params[:id])
    
    if @driver.nil?
      head :not_found
      return
    elsif @driver.update(driver_params)
      redirect_to driver_path(@driver)
      return
    else 
      render :edit, status: :bad_request
      return
    end
  end

  def destroy
    @driver = Driver.find_by(id: params[:id])
    
    if @driver.nil?
      head :not_found
      return
    else
      @driver.destroy
      redirect_to drivers_path
      return
    end
  end 

  def toggle_available
    @driver = Driver.find_by(id: params[:id])

    if @driver.nil?
      head :not_found
      return
    end
    
    # Update the driver's availability
    if @driver.available == false
      @driver.update(available: true)
      redirect_to driver_path
      return
    else 
      @driver.update(available: false)
      redirect_to driver_path
      return
    end   
  end

  private

  def driver_params
    return params.require(:driver).permit(:name, :vin, :available)
  end
end
