require 'test_helper'

class ParamsHelperTest < BaseControllerTest

  test "get_captcha_response with valid json should return response" do
    test_case = 'aasdasd-0adasdadsD35asdfad'
    json = {
        :captcha => test_case
    }

    response = ParamsHelper.get_captcha_response(json)
    assert_not_nil response
    assert_equal test_case, response
  end

  test "get_captcha_response when no repsonse should return empty" do
    test_case = ''
    json = {
        :captcha => test_case
    }

    response = ParamsHelper.get_captcha_response(json)
    assert_not_nil response
    assert_equal test_case, response
  end

  test "when no promo code should return nil" do
    codes = [nil, '']

    codes.each { |test_case|
      json = {
          :promo_code => {
              :code => test_case, :source => PromoCode::SOURCE_PURCHASING
          }
      }
      assert_nil ParamsHelper.parse_promo_code_query(json), "Test case: #{test_case} failed"
    }
  end

  test "when invalid promo code should throw" do
    json = {
        :promo_code => {
            :code => "aa", :source => PromoCode::SOURCE_PURCHASING
        }
    }
    assert_raises(ActiveRecord::RecordNotFound) {
      ParamsHelper.parse_promo_code_query(json)
    }
  end

  test "when valid promo code should return promo code" do
    test_case = PromoCode.first
    test_case.end_date = Time.now + 1.minute
    save test_case

    json = {
        :promo_code => {
            :code => test_case.code, :source => PromoCode::SOURCE_REGISTRATION
        }
    }

    promo = ParamsHelper.parse_promo_code_query(json)
    assert_not_nil promo
    assert_equal test_case.code, promo.code
  end

  test "When business params should return expected fields" do
    test_case = business_user_create_json
    params = ParamsHelper.business_params(test_case)
    assert_not_nil params
    assert_not_nil params[:company_name]
    assert_not_nil params[:phone_number]
    assert_not_nil params[:biography]
    assert_not_nil params[:website]
  end

  test "When communication params should return expected fields" do
    test_case = {communication: communication_json}
    params = ParamsHelper.communication_params(test_case)
    assert_not_nil params
    assert_not_nil params[:opt_in]
  end

  test "When business_tag_params should return expected fields" do
    test_case = business_tags_json
    params = ParamsHelper.business_tag_params(test_case)
    assert_not_nil params
    assert_not_nil params.fetch(0)[:id]
  end
end
