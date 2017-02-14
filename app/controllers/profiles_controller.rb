class ProfilesController < DeviseController
  # FIXME: Security does not work on this controller

  # FIXME: Fix the security
  public_routes = []
  user_routes = [:show,:set_profile_picture]
  business_routes = []

  skip_before_action :authenticate_user!, :only => public_routes
  skip_before_action :admin_only, :only => public_routes.concat(user_routes).concat(business_routes).concat(user_routes).concat(business_routes)
  before_action :user_only, :only => user_routes
  before_action :business_only, :only => business_routes


  def show
    self.resource = current_user
    @locations = current_user.locations
    @address = current_user.address
    @pictures = current_user.pictures
    @business = current_user.business
    @tab = tab_params.fetch(:tab, :account).to_sym
    render :profile
  end

  def set_profile_picture
    # TODO: Actually implement this
    puts "**********Here we are called ****"
    render json: {}, status: :ok
  end

  private
    def tab_params
      params.permit(:tab)
    end

    def picture_params
      params.require(:picture).permit(:id)
    end
end
