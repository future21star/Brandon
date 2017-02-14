class TermsAndConditionsController < ApplicationController
  public_routes = [:show]
  user_routes = [:accept, :has_accepted]
  business_routes = []

  skip_before_action :authenticate_user!, :only => public_routes
  skip_before_action :admin_only, :only => public_routes.concat(user_routes).concat(business_routes)
  before_action :user_only, :only => user_routes
  before_action :business_only, :only => business_routes

  def show
  end

  def accept
    params = accept_params
    @acceptance = UserAcceptanceOfTerms.new({:terms_and_conditions_id => params[:id]})
    @acceptance.user = current_user

    if @acceptance.save
      session[:terms_and_conditions_lock] = false
      render json: @acceptance
    else
      logger.warn "Trying to create @acceptance {#{@acceptance.inspect}} resulted in errors: #{@acceptance.errors.full_messages}"
      errors =  errors_to_hash(@acceptance)
      render json: errors, status: :unprocessable_entity
    end
  end

  def has_accepted
    render json: UserAcceptanceOfTerms.has_user_accepted?(:current_user)
  end

  private
    def accept_params
      params.require(:terms_and_conditions).permit(:id)
    end
end
