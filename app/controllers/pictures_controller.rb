require 'paperclip/attachment'
class PicturesController < ApplicationController
  public_routes = []
  user_routes = [:create, :destroy, :new]
  business_routes = []

  skip_before_action :authenticate_user!, :only => public_routes
  skip_before_action :admin_only, :only => public_routes.concat(user_routes).concat(business_routes)
  before_action :user_only, :only => user_routes
  before_action :business_only, :only => business_routes

  before_action :set_picture, only: [:show, :edit, :update, :destroy]

  # GET /pictures
  # GET /pictures.json
  def index
    @pictures = Picture.mine(current_user)
  end

  # GET /pictures/1
  # GET /pictures/1.json
  def show
  end

  # GET /pictures/new
  def new
    @picture = Picture.new
  end

  # GET /pictures/1/edit
  def edit
  end

  # POST /pictures
  # POST /pictures.json
  def create
    Picture.transaction do
      uploaded_io = picture_params[:file]
      ext = File.extname uploaded_io.original_filename
      generated_name = SecureRandom.urlsafe_base64(GENERATED_NAME_SIZE) + ext
      path =Rails.root.join(UPLOADS_PATH, generated_name)
      File.open(path, 'wb') do |file|
        file.write(uploaded_io.read)
      end
      @picture = Picture.new
      @picture.generated_name = generated_name
      @picture.a = uploaded_io
      @picture.user = current_user

      if @picture.save
        FogHelper.upload(path, generated_name)
        render json: (ImageDTO.instance_to_hash(@picture)), status: :created
      else
        logger.warn "Trying to create picture {#{@picture.inspect}} resulted in errors: #{@picture.errors.full_messages}"
        errors =  errors_to_hash(@picture)
        render json: errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /pictures/1
  # PATCH/PUT /pictures/1.json
  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to @picture, notice: 'Picture was successfully updated.' }
        format.json { render :show, status: :ok, location: @picture }
      else
        format.html { render :edit }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    if @picture.destroy
      redirect_to pictures_url, notice: 'Picture was successfully destroyed.'
    else
      logger.warn "Trying to delete picture {#{@picture.inspect}} resulted in errors: #{@picture.errors.full_messages}"
      errors =  errors_to_hash(@picture)
      render json: errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_picture
      @picture = Picture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def picture_params
      # params.require(:picture).permit(:id, :file_name, :content_type, :file_size)
      # params.require(:picture).permit(:id, :a)
      # params.require(:file)
      params
    end
end
