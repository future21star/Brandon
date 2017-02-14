class DashboardsController < ApplicationController
  public_routes = []
  user_routes = [:dashboard]
  business_routes = []

  skip_before_action :authenticate_user!, :only => public_routes
  skip_before_action :admin_only, :only => public_routes.concat(user_routes).concat(business_routes).concat(user_routes).concat(business_routes)
  before_action :user_only, :only => user_routes
  before_action :business_only, :only => business_routes


  def dashboard
    @latest_projects = ProjectDTO.instances_to_array_of_hashes(Project.summary(current_user))
    @latest_quotes = QuoteDTO.instances_to_array_of_hashes(Quote.summary(current_user))
    @latest_purchases = PurchaseDTO.instances_to_array_of_hashes(Purchase.summary(current_user))
    free = Bid.where(user: current_user, category: Category.find_by_name(BID_CATEGORY_FREE), consumed_at: nil).count
    paid = Bid.where(user: current_user, category: Category.find_by_name(BID_CATEGORY_PAID), consumed_at: nil).count
    @bid_stats = {Free: free, Paid: paid}
  end
end
