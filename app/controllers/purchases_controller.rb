class PurchasesController < ApplicationController
  include MyLogger

  public_routes = []
  user_routes = []
  business_routes = [:completed, :create, :index, :new, :show, :list_packages]

  skip_before_action :authenticate_user!, :only => public_routes
  skip_before_action :admin_only, :only => public_routes.concat(user_routes).concat(business_routes)
  before_action :user_only, :only => user_routes
  before_action :business_only, :only => business_routes

  before_action :business_only
  before_action :set_package, only: [:new, :create]
  before_action :set_purchase, only: [:completed, :show]

  # GET /purchases
  # GET /purchases.json
  def index
    default = 1
    page = params.fetch(:page, default)
    @purchases = Purchase.mine(current_user, page)
  end

  # GET /purchases/new
  def new
    @api_key = Rails.configuration.stripe[:publishable_key]
    @source = PromoCode::SOURCE_PURCHASING
  end

  # /purchase/:id
  def show
  end

  def completed
    render :completed
  end

  # POST /purchases
  # POST /purchases.json
  def create
    begin
      purchase = Purchase.new(history_params)
      purchase.package = @package
      purchase.user = current_user

      # Get the credit card details submitted by the form
      token = stripe_token_params

      # Create the charge on Stripe's servers - this will charge the user's card
      Purchase.transaction do
        promo = ParamsHelper.parse_promo_code_query(params)
        total = @package.total
        if promo
          total = promo.discount_price(total)
          purchase.promo_code = promo
          purchase.discount = @package.total - total
        end
        begin
            charge = Stripe::Charge.create(
                    :amount =>(total * 100).to_i(), # amount in cents
                    :currency => "cad",
                    :source => token[:id],
                    :description => "#{@package.quantity} bids purchased"
            )
            purchase.transaction_id = charge.id
            purchase.total = total

            if purchase.save
              render json: purchase
            else
              # This should NEVER happen, if it does, it requires immediate investigation
              logger.fatal "Trying to create purchase #{purchase.inspect} resulted in errors: #{purchase.errors.full_messages}"
              errors =  errors_to_hash(purchase)
              render json: errors, status: :unprocessable_entity
            end
        rescue Stripe::CardError => e
          logger.warn "Card declined for purchase #{purchase.inspect}"
          warn_exception(e)
          errors = [ "Your credit card was declined by Stripe, please contact support"]
          render json: errors, status: :unprocessable_entity
        end
      end
    rescue ActiveRecord::RecordNotFound
      render json: {:promo_code => "Promotion code is invalid"}, status: :bad_request
    end
  end

  def list_packages
    @packages = Package.all
    render :packages
  end

  private
    def set_package
      id = package_params
      @package = Package.find(id)
      unless @package
        raise ArgumentError.new("Accessed invalid package id")
      end
    end

    def set_purchase
      id = purchase_params[:id]
      @purchase = Purchase.where({:id => id, :user => current_user}).take
    end

    def package_params
      params.require(:package).require(:id)
    end

    def purchase_params
      params.permit(:id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def history_params
      params.require(:history).permit(:brand, :last_4, :exp_month, :exp_year)
    end

    def stripe_token_params
      params.require(:token)
    end
end
