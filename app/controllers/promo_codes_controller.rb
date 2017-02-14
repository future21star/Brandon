class PromoCodesController < ApplicationController
  public_routes = []
  user_routes = []
  business_routes = [:validate_promo_code]

  skip_before_action :authenticate_user!, :only => public_routes
  skip_before_action :admin_only, :only => public_routes.concat(user_routes).concat(business_routes)
  before_action :user_only, :only => user_routes
  before_action :business_only, :only => business_routes

  before_action :set_promo_code, only: [:show, :edit, :update, :cancel, :destroy]
  before_action :set_categories

  def set_categories
    @categories = []
    @categories << Category.find_by_name(PROMO_CODE_REGISTRATION)
    @categories << Category.find_by_name(PROMO_CODE_PURCHASE)
  end

  # GET /promo_codes
  # GET /promo_codes.json
  def index
    @promo_codes = PromoCode.all
  end

  # GET /promo_codes/1
  # GET /promo_codes/1.json
  def show
  end

  # GET /promo_codes/new
  def new
    @promo_code = PromoCode.new
  end

  # GET /promo_codes/1/edit
  def edit
  end

  # POST /promo_codes
  # POST /promo_codes.json
  def create
    @promo_code = PromoCode.new(promo_code_params)
    category = Category.find(category_params)
    @promo_code.category = category

    respond_to do |format|
      if @promo_code.save
        format.html { redirect_to @promo_code, notice: 'Promo code was successfully created.' }
        format.json { render :show, status: :created, location: @promo_code }
      else
        format.html { render :new }
        format.json { render json: @promo_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /promo_codes/1
  # PATCH/PUT /promo_codes/1.json
  def update
    respond_to do |format|
      if @promo_code.update(promo_code_params)
        format.html { redirect_to @promo_code, notice: 'Promo code was successfully updated.' }
        format.json { render :show, status: :ok, location: @promo_code }
      else
        format.html { render :edit }
        format.json { render json: @promo_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /promo_codes/1
  # DELETE /promo_codes/1.json
  def destroy
    @promo_code.destroy
    respond_to do |format|
      format.html { redirect_to promo_codes_url, notice: 'Promo code was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def cancel
    @promo_code.end_date = Time.now.utc
    if @promo_code.save
      render :show
    else
      render @promo_code
    end
  end

  def validate_promo_code
    # params = lookup_promo_code
    begin
      # TODO: Need to check if user has used the promo code before
      promo_code = ParamsHelper.parse_promo_code_query(params)
      render json: promo_code, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: [], status: :bad_request
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_promo_code
      @promo_code = PromoCode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def promo_code_params
      params.require(:promo_code).permit(:start_date, :end_date, :code, :discount, :description)
    end

    def category_params
      params.require(:category_id)
    end
end
