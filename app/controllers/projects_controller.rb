class ProjectsController < ApplicationController
  public_routes = [:search, :show, :index]
  user_routes = [:accept_quote, :cancel, :create, :create_tag, :destroy, :destroy_tag, :new, :publish, :report_as_spam, :update, :my_projects]
  business_routes = []

  skip_before_action :authenticate_user!, :only => public_routes
  skip_before_action :admin_only, :only => public_routes.concat(user_routes).concat(business_routes)
  before_action :user_only, :only => user_routes
  before_action :business_only, :only => business_routes

  before_action :set_project, only: [:show, :update, :destroy, :report_as_spam, :publish, :cancel, :accept_quote,
                                     :create_tag, :destroy_tag]
  before_action :set_measurement_data, only: [:new, :show]

  # GET /projects
  # GET /projects.json
  def index
    # TODO: Get tags from search (default to none)
    # TODO: Location should use users address, web location, or address fields. If all 3 blank, do not return anything
    tags =[Tag.first]
    latlng =  [43.499,-80.5544]
    # @summaries = ProjectSummary.by_tag(tags).in_range(latlng, params.fetch(:page, 1))
  end

  # GET /projects/search/lat/43.499/lng/-80.5544?tags=[]
  def search
    params = search_params
    latlng = [params[:lat], params[:lng]]
    tags = params[:tags].split(",").each { |id| Tag.find_by_id(id) }
    default = 1
    page = params.fetch(:page, default)

    summaries = ProjectSummary.by_tag(tags).in_range(latlng, page)
    dtos = ProjectSummaryDTO.instances_to_array_of_hashes(summaries)
    render json: dtos, status: :ok
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @quotes =  []
    if (@project.closed? or @project.accepted?)
      # Businesses can only see their quotes
      if current_user.is_business?
        @quotes = Quote.mine(current_user).find_by_project_id(@project.id)
        #Users can see all quotes if the project is closed
      elsif !current_user.nil? && current_user.id.equal?(@project.user.id)
        unless @project.quotes.empty?
          @quotes =  @project.quotes
        end
      end
    end
    unless @quotes
      @quotes =  []
    end
    @instance = ProjectDTO.instance_to_hash(@project)
    @rules = ProjectRules.new(@project, current_user)
    @tags = SimpleDTO.instances_to_array_of_hashes(Tag.all_alpha.where.not(id: @project.tags))
    return  @instance
  end

  # POST /projects/1/report_as_spam
  def report_as_spam
    logger.info "User: #{current_user.id} is flagging project as spam: #{@project.inspect}"
    SpamReport.report_project current_user.id, @project.id

    redirect_to @project, notice: 'Project was reported as spam and will be under investigation.'
  end

  def publish
    logger.info "User: #{current_user.id} is publishing project: #{@project.inspect}"
    @project.publish!
    redirect_to @project, notice: 'Project has been published.'
  end

  def cancel
    logger.info "User: #{current_user.id} is cancelling project: #{@project.inspect}"
    @project.cancel!
    redirect_to @project, notice: 'Project has been cancelled.'
  end

  # GET /projects/new
  def new
    @project = ProjectDTO.new
    @tags = SimpleDTO.instances_to_array_of_hashes(Tag.all)
  end

  # POST /projects
  # POST /projects.json
  def create
    projects_params = project_params
    user = current_user
    location = params_to_location
    unless location.persisted?
      location.users_locations << UsersLocation.new(:user => user, :location => location)
    end

    @project = Project.new(projects_params)
    @project.user = user
    @project.location = location

    measurement_groups = ParamsHelper.measurement_groups_params(params)
    measurement_groups.each { |measurement_group|
      group = ParamsHelper.measurement_group_params(measurement_group)
      @project.measurement_groups << MeasurementGroup.new(group)
      # FIXME: Validate that the quantifiers belong to the right categories
    }

    tags = tag_params
    tags.each { |tag|
      @project.project_tags << ProjectTag.new(:tag => Tag.find_by_id(tag[:id]))
    }

    pictures = ParamsHelper.pictures_params(params)
    pictures.each { |picture_params|
      picture = ParamsHelper.picture_params(picture_params)
      @project.project_pictures << ProjectPicture.new(
          :picture => Picture.find_by_generated_name(picture[:name])
      )
    }
    captcha_result = ParamsHelper.get_captcha_response(params)
    if verify_recaptcha(model: @project, response: captcha_result) && @project.save
      render json: @project, status: :created
    else
      logger.warn "Trying to create project {#{@project.inspect}} resulted in errors: #{@project.errors.full_messages}"
      errors =  errors_to_hash(@project)
      render json: errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      render head: :ok, json: @project
    else
      logger.warn "Trying to update project {#{@project.inspect}} resulted in errors: #{@project.errors.full_messages}"
      errors =  errors_to_hash(@project)
      render json: errors, status: :unprocessable_entity
    end
  end


  def create_tag
    tag_id = edit_tag_params[:id]

    project_tag = ProjectTag.new(:project_id => @project.id, :tag_id => tag_id)

    if project_tag.save
      render json: SimpleDTO.instance_to_hash(project_tag.tag), status: :created
    else
      logger.warn "Trying to create project tag {#{project_tag.inspect}} resulted in errors: #{project_tag.errors.full_messages}"
      errors =  errors_to_hash(project_tag)
      render json: errors, status: :unprocessable_entity
    end
  end

  def destroy_tag
    tag_id = edit_tag_params[:id]
    project_tag = ProjectTag.where({project_id: @project.id, tag_id: tag_id}).first

    if project_tag.nil?
      render json: [], status: :not_found
    elsif project_tag.destroy
      render json: [], status: :no_content
    else
      logger.warn "Trying to destroy project{#{project_tag.inspect}} resulted in errors: #{project_tag.errors.full_messages}"
      errors =  errors_to_hash(@project)
      render json: errors, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  # /projects/:id/accept/:estimate_id
  def accept_quote
    if @project.closed?
      @estimate = Estimate.find_by_id(accept_params[:estimate_id])
      User.transaction do
        @estimate.update_attribute(:accepted_at, Time.now)
        @project.accept!
        redirect_to @project, notice: 'You have successfully accepted the estimate.'
      end
    end
  end

  def my_projects
    clean_params = my_project_params
    default = 1
    page = clean_params.fetch(:page, default)
    @projects = Project.mine(current_user, page)
    render :mine
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_measurement_data
      @measurement_units = KeyValueHelper.create_from_quantifiers(Quantifier.by_category(QUANTIFIER_CATEGORY_DISTANCE))
      @measurement_types = KeyValueHelper.create_from_quantifiers(Quantifier.by_category(QUANTIFIER_CATEGORY_MEASUREMENT))
    end

    def params_to_location
      safe_params = location_params
      location = Location.new(safe_params)
      unless safe_params[:id].nil?
        location = Location.find(safe_params[:id])
      end
      return location
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_params
      params.permit(:lat, :lng, :page, :tags)
    end

    def project_params
      params.require(:project).permit(:state, :title, :summary, :description, :additional_comments, :id)
    end

    def tag_params
      params.require(:project_tags)
    end

    def edit_tag_params
      params.require(:tag).permit(:id)
    end

    def accept_params
      params.permit(:id, :estimate_id)
    end

    def location_params
      params.require(:location).permit(:id, :latitude, :longitude, :name)
    end

    def my_project_params
      params.permit(:page)
    end
end
