class FeedbacksController < ApplicationController
  public_routes = [:new, :create, :completed]
  user_routes = []
  business_routes = []

  skip_before_action :authenticate_user!, :only => public_routes
  skip_before_action :admin_only, :only => public_routes.concat(user_routes).concat(business_routes).concat(user_routes).concat(business_routes)
  before_action :user_only, :only => user_routes
  before_action :business_only, :only => business_routes

  # GET /feedbacks/new
  def new
    @feedback = Feedback.new
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = Feedback.new(feedback_params)

      captcha_result = ParamsHelper.get_captcha_response(params)
      if verify_recaptcha(model: @feedback, response: captcha_result) && @feedback.save
        flash[:notice] = 'Thank you for your feedback'
        subject = "Feedback from #{@feedback.name}"
        body = "From #{@feedback.email}\nName: #{@feedback.name}\n\n#{@feedback.content}"
        message = QuotrMailer.system_message subject, body
        message.deliver_later
        render json: @feedback, status: :created
      else
        logger.warn "Trying to create @feedback {#{@feedback.inspect}} resulted in errors: #{@feedback.errors.full_messages}"
        errors =  errors_to_hash(@feedback)
        render json: errors, status: :unprocessable_entity
      end
  end

  def completed
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def feedback_params
      params.require(:feedback).permit(:name, :email, :content)
    end
end
