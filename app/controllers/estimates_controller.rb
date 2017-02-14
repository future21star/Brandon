class EstimatesController < ApplicationController
  public_routes = []
  user_routes = []
  business_routes = [:create, :destroy, :update, :my_estimates]

  skip_before_action :authenticate_user!, :only => public_routes
  skip_before_action :admin_only, :only => public_routes.concat(user_routes).concat(business_routes)
  before_action :user_only, :only => user_routes
  before_action :business_only, :only => business_routes

  before_action :set_estimate, only: [:update, :destroy]

  # GET /estimates
  # GET /estimates.json
  def index
    @instances = Estimate.all
    @quantifiers = Quantifier.all
  end

  # POST /estimates
  # POST /estimates.json
  def create
    Estimate.transaction do
      estimates_params = estimate_params
      @estimate = Estimate.new(estimates_params)

      if estimates_params[:quote_id] && estimates_params[:quote_id].strip != ''
        quote = Quote.find_by_id(estimates_params[:quote_id])
      else
        quote = Quote.new
        quote.project = Project.find_by_id quote_params[:project_id]
        quote.business = current_user.business
      end
      @estimate.quote = quote

      # in the event of a stale object, pass back a 409
      begin
        if @estimate.save
          render json: @estimate
        else
          msg = "Trying to create estimate {#{@estimate.inspect}} resulted in errors: #{@estimate.errors.full_messages}"
          logger.warn msg
          errors =  errors_to_hash(@estimate)
          render json: errors, status: :unprocessable_entity
        end
      rescue ActiveRecord::StaleObjectError
        logger.warn "Trying to create estimate {#{@estimate.inspect}} resulted in stale object error."
        errors = ["A problem was detected, please try your request again in a moment"]
        render json: errors, status: :conflict
      end
    end
  end

  # PATCH/PUT /estimates/1
  # PATCH/PUT /estimates/1.json
  def update
      if @estimate.update(estimate_params)
        render json: @estimate
      else
        logger.warn "Trying to update estimate {#{@estimate.inspect}} resulted in errors: #{@estimate.errors.full_messages}"
        errors =  errors_to_hash(@estimate)
        render json: errors, status: :unprocessable_entity
      end
  end

  # DELETE /estimates/1
  # DELETE /estimates/1.json
  def destroy
    @estimate.destroy
    respond_to do |format|
      format.html { redirect_to estimates_url, notice: 'Estimate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def my_estimates
    user = current_user
    clean_params = my_estimate_params
    default = 1
    page = clean_params.fetch(:page, default)
    @quotes = Quote.mine(user, page)
    # render json: quotes, status: :ok
    render :mine
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_estimate
      @estimate = Estimate.find(params[:id])
    end

    def quote_params
      params.require(:quote).permit(:project_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def estimate_params
      params.require(:estimate).permit(:id, :summary, :description, :price, :duration, :quantifier_id, :quote_id)
    end

    def my_estimate_params
      params.permit(:page)
    end
end
