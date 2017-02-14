require 'test_helper'

class TermsAndConditionsControllerTest < BaseControllerTest
  setup do
    user_sign_in
  end

  test "should post accept" do
    new_user = create_cooked_user
    save new_user
    
    assert_difference('UserAcceptanceOfTerms.count') do
      post :accept, terms_and_conditions: { id: TermsAndConditions.latest.id }
    end
  end

  test "should get has_accepted" do
    get :has_accepted
    assert_response :success
  end

end
