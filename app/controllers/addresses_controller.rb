class AddressesController < ApplicationController
  public_routes = []
  user_routes = [:update, :show]
  business_routes = []

  skip_before_action :authenticate_user!, :only => public_routes
  skip_before_action :admin_only, :only => public_routes.concat(user_routes).concat(business_routes).concat(user_routes).concat(business_routes)
  before_action :user_only, :only => user_routes
  before_action :business_only, :only => business_routes

  before_action :set_address, only: [:show, :edit, :update, :destroy]

  # GET /addresses
  # GET /addresses.json
  def index
    @addresses = Address.all
    @countries = AddressesHelper.get_country_list
  end

  # GET /addresses/1
  # GET /addresses/1.json
  def show
  end

  # GET /addresses/new
  def new
    @address = Address.new
    @countries = AddressesHelper.get_country_list
    canada = @countries[0]
    usa = @countries[1]
    canadian_provinces =AddressesHelper.get_province_list(canada)
    yank_states =AddressesHelper.get_province_list(usa)
    @provinces = [canada.id => canadian_provinces, usa.id => yank_states]
  end

  # GET /addresses/1/edit
  def edit
  end

  # POST /addresses
  # POST /addresses.json
  def create
    @address = Address.new(address_params)

    if @address.save
      render json: @address
    else
      logger.warn "Trying to create address {#{@address.inspect}} resulted in errors: #{@address.errors.full_messages}"
      errors =  errors_to_hash(@address)
      render json: errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      @address.assign_attributes(address_params)
      begin
        geo_info = LocationHelper::geocode_by_address @address
        @address.location = nil
        @address.location = Location.new(address: @address, latitude: geo_info.latitude, longitude: geo_info.longitude)
        @address.user.users_locations << UsersLocation.new(user: @address.user, location: @address.location)
      rescue (StandardError)
        logger.warn "Invalid address provided....#{@address.inspect}"
        @address.errors.add(:base, 'Address is invalid')
        errors =  errors_to_hash(@address)
        render json: errors, status: :unprocessable_entity
        return
      end

      if @address.save
        format.html { redirect_to @address, notice: 'Address was successfully updated.' }
        format.json { render json: @address, status: :ok}
      else
        logger.warn "Trying to update address {#{@address.inspect}} resulted in errors: #{@address.errors.full_messages}"
        errors =  errors_to_hash(@address)
        format.html { render :edit }
        format.json { render json: errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.json
  def destroy
    @address.destroy
    respond_to do |format|
      format.html { redirect_to addresses_url, notice: 'Address was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params.require(:address).permit(:id, :house_number, :postal_code, :apartment, :city, :street_name, :province_id)
    end
end
