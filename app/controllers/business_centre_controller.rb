class BusinessCentreController < ApplicationController

  def account_search
    params = account_search_params

    default = 1
    page = params.fetch(:page, default)

    @accounts = User.search params[:first_name], params[:last_name], params[:email], page

    if @accounts && !@accounts.empty?
      render :account_search, status: :ok
    else
      render :account_search, status: :not_found
    end
  end

  def business_search
    params = business_search_params

    default = 1
    page = params.fetch(:page, default)

    @businesses = Business.search params[:company_name], params[:phone_number], params[:website], page

    if @businesses && !@businesses.empty?
      render :business_search, status: :ok
    else
      render :business_search, status: :not_found
    end
  end

  private
    def account_search_params
      params.permit(:email, :first_name, :last_name, :page)
    end

    def business_search_params
      params.permit(:company_name, :phone_number, :website, :page)
    end
end
