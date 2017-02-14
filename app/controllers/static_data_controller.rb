class StaticDataController < ApplicationController
  public_routes = [:map_data, :captcha_key, :get_eula]
  user_routes = []
  business_routes = []

  skip_before_action :authenticate_user!, :only => public_routes
  skip_before_action :admin_only, :only => public_routes.concat(user_routes).concat(business_routes)
  before_action :user_only, :only => user_routes
  before_action :business_only, :only => business_routes

  def map_data
    json = {
      api_key: API_KEY
    }
    render json: json, status: :ok
  end

  def captcha_key
    json = {
     site_key: Recaptcha.configuration.public_key
    }
    render json: json, status: :ok
  end

  def get_eula
    json = {
      instance: SimpleDTO.instance_to_hash(TermsAndConditions.latest)
    }
    render json: json, status: :ok
  end
end
