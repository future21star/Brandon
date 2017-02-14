class Users::RegistrationsController < Devise::RegistrationsController
  public_routes = [:completed, :create, :new]
  user_routes = [:cancel, :edit, :update]
  business_routes = []

  skip_before_action :authenticate_user!, :only => public_routes
  skip_before_action :admin_only, :only => public_routes.concat(user_routes).concat(business_routes)
  before_action :user_only, :only => user_routes
  before_action :business_only, :only => business_routes

  # before_action :authenticate_user!, :only => [:edit, :update, :destroy]
  # before_action :only_admin, :only => [:destroy]
  before_action :set_common_data, only: [:new, :edit]
  before_action :configure_permitted_parameters, only: :update

  def new
    business_param = params[:business]
    @business_signup = business_param ? business_param.to_b : false
    @tags = SimpleDTO.instances_to_array_of_hashes(Tag.all_alpha)

    @source = PromoCode::SOURCE_REGISTRATION
  end

  def edit
    @user = current_user
    business = @user.business
    # @preference = current_user.preference
    @locations = current_user.locations
    @address = AddressDTO.instance_to_hash(@user.address)
    # @address = AddressDTO.instance_to_hash(current_user.address)
    @pictures = ImageDTO.instances_to_array_of_hashes(current_user.pictures)
    # @pictures = ImageDTO.instances_to_array_of_hashes(current_user.pictures)
    @business =  business ? BusinessDTO.instance_to_hash(business) : nil
    @preferences = PreferencesDTO.instances_to_array_of_hashes(@user.user_preferences)
    @tags = business ? SimpleDTO.instances_to_array_of_hashes(Tag.all.where.not(id: business.tags)) :
        SimpleDTO.instances_to_array_of_hashes(Tag.all)
    tab = tab_params
    @tab = tab.blank? ? nil : tab[:tab]
    @user = UserDTO.instance_to_hash(@user)

    @rules = {}
  end

  # POST /resource
  def create
    begin
      User.transaction do
        creating_business = (creating_params[:business])
        address = Address.new(address_params)
        province = Province.find_by_id(address_params[:province_id])
        address.province = province
        business = nil

        begin
          geo_info = LocationHelper::geocode_by_address address
          address.location = Location.new(latitude: geo_info.latitude, longitude: geo_info.longitude)
        rescue (StandardError)
          logger.warn "Invalid address provided....#{address.inspect}"
          address.errors.add(:base, 'Address is invalid')
          errors =  errors_to_hash(address)
          render json: errors, status: :unprocessable_entity
          return
        end

        if creating_business
          business = CreationHelper.create_business(params)
        end

        user = User.new(user_params)
        user.address = address
        user.business = business
        user.opt_in = communication_params[:opt_in]

        captcha_result = ParamsHelper.get_captcha_response(params)
        if verify_recaptcha(model: user, response: captcha_result) && user.save
          if creating_business
            clamp = true
            promo = ParamsHelper.parse_promo_code_query(params)
            bids = MAX_FREE_BIDS
            if promo
              bids += promo.discount
              clamp = false
            end
            time = Time.now.utc
            BidHelper.create_accounts_top_up user.id, bids, time, time, nil, clamp
          end
          render json: user, status: :created
        else
          logger.warn "Trying to create user {#{user.inspect}} resulted in errors: #{user.errors.full_messages}"
          errors =  errors_to_hash(user, method(:custom_parser))
          render json: errors, status: :unprocessable_entity
        end
      end
    rescue ActiveRecord::RecordNotFound
      render json: {:promo_code => "Promotion code is invalid"}, status: :bad_request
    end
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      sign_in resource_name, resource, bypass: true
      render json: resource, status: :ok
    else
      clean_up_passwords resource
      logger.warn "Trying to update user {#{resource.inspect}} resulted in errors: #{resource.errors.full_messages}"
      errors =  errors_to_hash(resource, method(:custom_parser))
      render json: errors, status: :unprocessable_entity
    end
  end

  def completed
    @user = User.find(params[:id])
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password)
    end

    def passwords
      params.require(:user).permit(:password, :confirm_password)
    end

    def address_params
      params.require(:address).permit(:id, :house_number, :postal_code, :apartment, :city, :street_name, :province_id)
    end

    def tag_params
      params.require(:business_tags)
    end

    def communication_params
      params.require(:communication).permit(:opt_in)
    end

    def creating_params
      params.require(:creating).permit(:business)
    end

    def tab_params
      params.permit(:tab)
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update) { |u|
        u.permit(:email, :first_name, :last_name, :password, :password_confirmation, :current_password)
      }
    end

    def set_common_data
      @countries = AddressesHelper.get_country_list
      canada = @countries[0]
      usa = @countries[1]
      canadian_provinces =AddressesHelper.get_province_list(canada)
      yank_states =AddressesHelper.get_province_list(usa)
      @provinces = [canada.id => canadian_provinces, usa.id => yank_states]
    end

    def custom_parser(key)
      return simple_error_nest_scrubber(key, ['address', 'user', 'business'])
    end
end
