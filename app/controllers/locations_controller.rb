 class LocationsController < ApplicationController
  public_routes = []
  user_routes = [:update, :my_locations]
  business_routes = []

  skip_before_action :authenticate_user!, :only => public_routes
  skip_before_action :admin_only, :only => public_routes.concat(user_routes).concat(business_routes)
  before_action :user_only, :only => user_routes
  before_action :business_only, :only => business_routes

  before_action :set_location, only: [:update]

  def create_url
    @maps_url = MAPS_URL
  end

  # GET /locations
  # GET /locations.json
  def index
    # default = 1
    # page = params.fetch(:page, default)
    # @locations = Location.mine(current_user).paginate(:page => page)
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    create_url
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
    create_url
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { render json: @location, status: :ok }
      else
        logger.warn "Trying to update location {#{@location.inspect}} resulted in errors: #{@location.errors.full_messages}"
        errors =  errors_to_hash(@location)
        format.html { render :edit }
        format.json { render json: errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def my_locations
    user = current_user
    location = LocationDTO.instance_to_hash(user.address.location)
    locations = LocationDTO.instances_to_array_of_hashes(Location.mine(user).have_names.only_visible)
    location_data = {
        location: location,
        locations: locations
    }
    render json: location_data
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:visible, :name, :page)
    end
end
