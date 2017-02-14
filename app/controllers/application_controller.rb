class ApplicationController < ActionController::Base
  include MyLogger
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session


  # Lock down every method in children, but all methods in the base class should be exposed
  before_action :authenticate_user!
  before_action :admin_only#, :except => [:redirect_callback, :warn_exception, :redirect_to_401, :role_only, :admin_only, :user_only,
  # :business_only, :errors_to_hash, :after_sign_in_path_for, :after_sign_out_path_for]

  before_action :set_paper_trail_whodunnit, :prepare_exception_notifier, :set_common_data
  before_action { TermsAndConditionsInterceptor.before(user_signed_in?, session, controller_name, method(:redirect_callback)) }


  def redirect_callback(path)
    redirect_to path
  end

  def warn_exception(exception, args=nil)
    logger.warn("Received #{exception}, class #{self.class.name} failed with #{args}")
    logger.warn exception.message
    if exception.backtrace
      logger.warn exception.backtrace.join("\n")
    end
  end

  def redirect_to_401
    render file: "public/401", status: :unauthorized
    # redirect_to "/401", :alert => "Access denied."
  end

  def role_only(role)
    if current_user
      # this only redirects to 401 IF the user is signed in, otherwise it redirects them to the login page
      unless current_user.has_role(role)
        redirect_to_401
      end
    else
      # redirect_to :new_user_session_path
    end
  end

  def admin_only
    role_only ROLE_ADMIN
  end

  def user_only
    role_only ROLE_USER
  end

  def business_only
    role_only ROLE_BUSINESS
  end

  def errors_to_hash(instance, parser=nil)
    count = 0
    errors = instance.errors.as_json
    base_errors = errors[:base]
    base_errors ||= []
    clean_errors = {}
    has_added_field_error_msg = false
    errors.select do |key, value|
      if parser
        key = parser.call(key)
      end
      key = key.to_sym
      # Take the first field errror
      clean_errors[key] = value[0]
      if key == :base
        base_errors << value[0]
      elsif !has_added_field_error_msg
        base_errors << BASE_FIELD_ERROR_TEXT
        has_added_field_error_msg = true
      end
      count+=1
    end
    clean_errors[:count] = count
    clean_errors[:base] = base_errors
    return clean_errors
  end

  def simple_error_nest_scrubber(key, models)
    if key
      models.each { |model|
        if key.to_s.start_with?(model)
          key = key.to_s.gsub(model + '.', '')
        end
      }
      return key
    end
  end

  def after_sign_in_path_for(resource)
    if UserAcceptanceOfTerms.has_user_accepted?(resource)
      if resource.is_admin?
        :admin_landing_page
      elsif resource.is_business?
        :business_landing_page
      elsif resource.is_user?
        :user_landing_page
      else
        raise ArgumentError.new("Should never be hit but somehow this user did: #{resource.inspect}")
      end
    else
      session[:terms_and_conditions_lock] = true
      :terms_and_conditions
    end
  end

  def after_sign_out_path_for(resource)
    :new_user_session
  end

  private
    def prepare_exception_notifier
      request.env["exception_notifier.exception_data"] = {
          :current_user => current_user
      }
    end

    def set_common_data
      @show_business_centre = AccessHelper.user_has_role(ROLE_ADMIN, current_user)
    end
end
