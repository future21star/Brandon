
#White listed controller names
WHITE_LIST = [:terms_and_conditions.to_s, :landing_page.to_s, "sessions", :static_pages.to_s,
              :static_data.to_s, :feedbacks.to_s]

class TermsAndConditionsInterceptor
  class << self
    def before(user_signed_in, session, controller_name, redirect)
      if user_signed_in
        if session[:terms_and_conditions_lock]
          unless WHITE_LIST.include? controller_name
            redirect.call(:terms_and_conditions)
          end
        end
      end
    end
  end
end