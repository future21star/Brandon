class PreferencesController < ApplicationController
  public_routes = []
  user_routes = [:update]
  business_routes = []

  skip_before_action :authenticate_user!, :only => public_routes
  skip_before_action :admin_only, :only => public_routes.concat(user_routes).concat(business_routes)
  before_action :user_only, :only => user_routes
  before_action :business_only, :only => business_routes

  before_action :set_preference, only: [:show, :edit, :destroy]

  # GET /preferences
  # GET /preferences.json
  def index
    @user_preferences = Preference.all
  end

  # GET /preferences/1
  # GET /preferences/1.json
  def show
    @user_preferences = current_user.user_preferences
    redirect_to @user_preference.preference
  end

  # GET /preferences/new
  def new
    @user_preference = Preference.new
  end

  # GET /preferences/1/edit
  def edit
  end

  # POST /preferences
  # POST /preferences.json
  def create
    @user_preference = Preference.new(preference_params)
    @user_preference.user = current_user

    respond_to do |format|
      if @user_preference.save
        format.html { redirect_to @user_preference, notice: 'Preference was successfully created.' }
        format.json { render :show, status: :created, location: @user_preference }
      else
        format.html { render :new }
        format.json { render json: @user_preference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /preferences/1
  # PATCH/PUT /preferences/1.json
  def update
    instances = []
    errors = []
    UserPreference.transaction do
      preferences = ParamsHelper.parse_user_preferences(params)
      preferences.each { |preference|
        preference = ParamsHelper.user_preference_params(preference)
        user_preference = UserPreference.find(preference[:id])
        if user_preference.update(preference)
          instances << user_preference
        else
          logger.warn "Trying to update preference{#{user_preference.inspect}} resulted in errors: #{user_preference.errors.full_messages}"
          errors =  errors_to_hash(user_preference)
          render json: errors, status: :unprocessable_entity
          raise ActiveRecord::Rollback
        end
      }
    end
    if errors.empty?
      render json: PreferencesDTO.instances_to_array_of_hashes(instances), status: :ok
    end
  end

  # DELETE /preferences/1
  # DELETE /preferences/1.json
  def destroy
    @user_preference.destroy
    respond_to do |format|
      format.html { redirect_to preferences_url, notice: 'Preference was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_preference
      @user_preference = UserPreference.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def preference_params
      params.require(:user_preferences).permit([:id, :email, :internal])
    end
end
