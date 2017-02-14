class BusinessesController < ApplicationController
  public_routes = []
  user_routes = [:create]
  business_routes = [:create_tag, :destroy_tag, :update]

  skip_before_action :authenticate_user!, :only => public_routes
  skip_before_action :admin_only, :only => public_routes.concat(user_routes).concat(business_routes).concat(user_routes).concat(business_routes)
  before_action :user_only, :only => user_routes
  before_action :business_only, :only => business_routes

  before_action :set_business, only: [:show, :edit, :update, :destroy]

  # GET /businesses
  # GET /businesses.json
  def index
    @businesses = Business.all
  end

  # GET /businesses/1
  # GET /businesses/1.json
  def show
  end

  # GET /businesses/new
  def new
    @business = Business.new
  end

  # GET /businesses/1/edit
  def edit
  end

  # POST /businesses
  # POST /businesses.json
  def create
    @business = CreationHelper.create_business(params)
    @business.user = current_user

    respond_to do |format|
      if @business.save
        format.html { redirect_to @business, notice: 'Business was successfully created.' }
        format.json { render json: BusinessDTO.instance_to_hash(@business), status: :created}
      else
        logger.warn "Trying to create business{#{@business.inspect}} resulted in errors: #{@business.errors.full_messages}"
        errors =  errors_to_hash(@business)
        format.html { render :new }
        format.json { render json: errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /businesses/1
  # PATCH/PUT /businesses/1.json
  def update
    if @business.update(ParamsHelper.business_params(params))
      render json: BusinessDTO.instance_to_hash(@business), status: :ok
    else
      logger.warn "Trying to update business{#{@business.inspect}} resulted in errors: #{@business.errors.full_messages}"
      errors =  errors_to_hash(@business)
      render json: errors, status: :unprocessable_entity
    end
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.json
  def destroy
    @business.destroy
    respond_to do |format|
      format.html { redirect_to businesses_url, notice: 'Business was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def create_tag
    business = current_user.business
    tag_id = tag_params[:id]

    business_tag = BusinessTag.new(:business_id => business.id, :tag_id => tag_id)

    if business_tag.save
      render json: SimpleDTO.instance_to_hash(business_tag.tag), status: :created
    else
      logger.warn "Trying to create business_tag{#{business_tag.inspect}} resulted in errors: #{business_tag.errors.full_messages}"
      errors =  errors_to_hash(business_tag)
      render json: errors, status: :unprocessable_entity
    end
  end

  def destroy_tag
    business = current_user.business
    tag_id = tag_params[:id]
    business_tag = BusinessTag.where({business_id: business.id, tag_id: tag_id}).first

    if business_tag.nil?
      render json: [], status: :not_found
    elsif business_tag.destroy
      render json: [], status: :no_content
    else
      logger.warn "Trying to destroy business_tag{#{business_tag.inspect}} resulted in errors: #{business_tag.errors.full_messages}"
      errors =  errors_to_hash(@business)
      render json: errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business
      @business = Business.find(params[:id])
    end

    def tag_params
      params.require(:tag).permit(:id)
    end
end
