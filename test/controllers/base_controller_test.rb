require 'test_helper'

require_relative('./json_builder')

class BaseControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  include JSONBuilder

  def get_admin
    users(:one)
  end

  def get_business
    Business.first.user
  end

  def get_user
    users(:regular)
  end

  def admin_sign_in
    sign_in get_admin
  end

  def business_sign_in
    sign_in  get_business
  end

  def user_sign_in
    sign_in get_user
  end

  def sign_out_all
    sign_out get_user
    sign_out get_business
    sign_out get_admin
  end

  def devise_user_mapping
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  #         SECURITY HELPERS
  def verb_with_user(verb, action, args={}, user=nil)
    if user
      sign_in user
    end
    # args[:format] = :json
    self.send(verb, action, args)
  end

  def run_role_get_security(action, args={}, role=nil, expected_response=nil, setup=nil)
    run_role_security('get', action, args, role, expected_response, setup)
  end

  def run_role_post_security(action, args={}, role=nil, expected_response=nil, setup=nil)
    run_role_security('post', action, args, role, expected_response, setup)
  end

  def run_role_patch_security(action, args={}, role=nil, expected_response=nil, setup=nil)
    run_role_security('patch', action, args, role, expected_response, setup)
  end

  def run_role_delete_security(action, args={}, role=nil, expected_response=nil, setup=nil)
    run_role_security('delete', action, args, role, expected_response, setup)
  end

  def run_role_security(verb, action, args, role, expected_response, setup)
    verb = verb.downcase
    expectations = get_role_expectations(role)
    expected_to_accept = expectations[:expected_to_accept]
    expected_to_reject = expectations[:expected_to_reject]

    expected_to_accept.each { |user|
      User.transaction(requires_new: true) do
        sign_out_all
        if setup
          setup.call(user)
        end
        verb_with_user(verb, action, args, user)
        content_type = @response.header['Content-Type']
        is_html = content_type && (content_type.include?('html') || (content_type.is_a?(Mime) && content_type.html?))
        if expected_response
          expected_response.call(user, args, verb)
        elsif verb == 'post'
          if is_html
            assert_response :redirect
          else
            assert_response :created
          end
        elsif verb =='delete'
          assert_response :no_content
        else
          assert_response :ok
        end
        raise ActiveRecord::Rollback, "Resetting the data model"
      end
    }

    # puts "********** NEGATIVE CASES STARTING ****"
    expected_to_reject.each { |user|
      sign_out_all
      verb_with_user(verb, action, args, user)
      content_type = @response.header['Content-Type']
      is_json = content_type.include?('application/json')
      # Logged in users are redirected to the 401 screen, whereas unauthenticated users are sent to the login screen unless the
      # request is in JSON, in which case it returns an unauthorized as well
      if user || is_json
        assert_response :unauthorized
      else
        assert_redirected_to new_user_session_path
      end
    }
  end

  private
    def get_role_expectations(role)
      expected_to_accept = []
      expected_to_reject = []
      if role == nil
        expected_to_accept << nil
        expected_to_accept << get_admin
        expected_to_accept << get_business
        expected_to_accept << get_user
      end

      if role == ROLE_USER
        expected_to_accept << get_user
        expected_to_accept << get_business
        expected_to_accept << get_admin

        expected_to_reject << nil
      end

      if role == ROLE_BUSINESS
        expected_to_accept << get_business
        expected_to_accept << get_admin

        expected_to_reject << get_user
        expected_to_reject << nil
      end

      if role == ROLE_ADMIN
        expected_to_accept << get_admin

        expected_to_reject << get_business
        expected_to_reject << get_user
        expected_to_reject << nil
      end

      {expected_to_accept: expected_to_accept, expected_to_reject: expected_to_reject}
    end
end
