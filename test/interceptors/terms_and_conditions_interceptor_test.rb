require 'test_helper'

class TermsAndConditionsInterceptorTest < BaseControllerTest

  def callback(path)
    assert_equal :terms_and_conditions, path
  end

  def should_never_callback
    fail("this should have never been called")
  end

  test "Every route except whitelist should redirect when terms and conditions lock set" do
    session = {}
    session[:terms_and_conditions_lock] = true
    routes= Rails.application.routes.routes.map do |route|
      {alias: route.name, path: route.path.spec.to_s, controller: route.defaults[:controller], action: route.defaults[:action]}
      controller_name = route.defaults[:controller]
      # def before(user_signed_in, session, controller_name, redirect)
      if WHITE_LIST.include? controller_name
        TermsAndConditionsInterceptor.before(true, session, controller_name, method(:should_never_callback))
      else
        TermsAndConditionsInterceptor.before(true, session, controller_name, method(:callback))
      end
      # end
    end
    assert_not_nil routes
    assert_not_equal 0, routes.size
  end
end
