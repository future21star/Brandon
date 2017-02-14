class StaticPagesController < ApplicationController
  public_routes = [:privacy_policy, :terms_and_conditions]
  user_routes = []
  business_routes = []

  skip_before_action :authenticate_user!, :only => public_routes
  skip_before_action :admin_only, :only => public_routes.concat(user_routes).concat(business_routes).concat(user_routes).concat(business_routes)
  before_action :user_only, :only => user_routes
  before_action :business_only, :only => business_routes

  def privacy_policy
  end

  def terms_and_conditions
    @instance = TermsAndConditions.latest
  end

end
