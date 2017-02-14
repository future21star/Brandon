class RatingsController < ApplicationController
  public_routes = []
  user_routes = [:create, :destroy, :edit, :get_business_ratings, :new, :show, :update]
  business_routes = []

  skip_before_action :authenticate_user!, :only => public_routes
  skip_before_action :admin_only, :only => public_routes.concat(user_routes).concat(business_routes)
  before_action :user_only, :only => user_routes
  before_action :business_only, :only => business_routes

  before_action :set_rating, only: [:show, :edit, :update, :destroy]

  # GET /ratings
  # GET /ratings.json
  def index
    #not used
    @ratings = Rating.all
    render json: @ratings
  end

  # GET /ratings/1
  # GET /ratings/1.json
  def show
    render json: @rating
  end

  # GET /ratings/new
  def new
    @rating = Rating.new
  end

  # GET /ratings/1/edit
  def edit
    render json: @rating
  end

  # POST /ratings
  # POST /ratings.json
  def create
    params = rating_params
    @rating = Rating.new(params)
    @rating.user = current_user

    if @rating.save
      render json: @rating
    else
      logger.warn "Trying to create rating {#{@rating.inspect}} resulted in errors: #{@rating.errors.full_messages}"
      errors =  errors_to_hash(@rating)
      render json: errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ratings/1
  # PATCH/PUT /ratings/1.json
  def update
    if @rating.update(rating_params)
      render head: :ok, json: @rating
    else
      logger.warn "Trying to update @rating {#{@rating.inspect}} resulted in errors: #{@rating.errors.full_messages}"
      errors =  errors_to_hash(@rating)
      render json: errors, status: :unprocessable_entity
    end
  end

  # DELETE /ratings/1
  # DELETE /ratings/1.json
  def destroy
    if @rating.user.id == current_user.id
      if @rating.destroy
        render head: :no_content, json: @rating
      else
        logger.warn "Trying to delete @rating {#{@rating.inspect}} resulted in errors: #{@rating.errors.full_messages}"
        errors =  errors_to_hash(@rating)
        render json: errors, status: :unprocessable_entity
      end
    else
      logger.warn "Trying to delete @rating {#{@rating.inspect}} that is not theirs!"
      @rating.errors[:rating] = 'Unable to delete ratings that are not your own'
      render json: errors, status: :unprocessable_entity
    end
  end

  def get_business_ratings
    params = rating_lookup_params
    data = Rating.business_general_ratings(params[:business_id], params[:page])
    render json: RatingsDTO.create_from_array(data)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rating
      @rating = Rating.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_params
      params.require(:rating).permit(:business_id, :rating_definition_id, :rating, :comments)
    end

    def rating_lookup_params
      params.permit(:business_id, :page)
    end
end
