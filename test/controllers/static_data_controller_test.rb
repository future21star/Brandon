require 'test_helper'

class StaticDataControllerTest < BaseControllerTest
  setup do

  end

  test "map_data should retrieve expected" do
    get :map_data
    assert_response :ok
    data = JSON.parse(@response.body).symbolize_keys
    assert_not_nil data
    assert_not_nil data[:api_key]
    assert_equal API_KEY, data[:api_key]
  end

  test "captcha_key should retrieve captcha_key" do
    get :captcha_key
    assert_response :ok
    data = JSON.parse(@response.body).symbolize_keys
    assert_not_nil data
    assert_not_nil data[:site_key]
    assert_equal Recaptcha.configuration.public_key, data[:site_key]
  end

  test "get_eula should retrieve captcha_key" do
    terms = TermsAndConditions.latest
    get :get_eula
    assert_response :ok
    data = JSON.parse(@response.body).symbolize_keys
    assert_not_nil data
    assert_not_nil data[:instance]
    assert_equal terms.eula, data[:instance].symbolize_keys[:eula]
  end
end
