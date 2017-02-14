require 'test_helper'

class BusinessCentreControllerTest < BaseControllerTest

  setup do
    admin_sign_in
  end

  test "account_search should search by only partial email" do
    test_case = User.first.email[2..4]

    get :account_search, get_account_params('', '', test_case)

    assert_response :success
    assert_not_nil assigns(:accounts)
  end

  test "account_search should search by only partial first name" do
    test_case = User.first.first_name[2..4]

    get :account_search, get_account_params(test_case)

    assert_response :success
    assert_not_nil assigns(:accounts)
  end

  test "account_search should search by only partial last name" do
    test_case = User.first.last_name[2..4]

    get :account_search, get_account_params('', test_case, '')

    assert_response :success
    assert_not_nil assigns(:accounts)
  end

  test "account_search should search even when no parameters" do
    get :account_search, get_account_params

    assert_response :success
    assert_not_nil assigns(:accounts)
  end

  test "account_search should search with all parameters" do
    user = User.first
    get :account_search, get_account_params(user.first_name[1..2], user.last_name[0..2], user.email[1.1])

    assert_response :success
    assert_not_nil assigns(:accounts)
  end

  test "account_search no data should return error" do
    get :account_search, get_account_params('asda4adasd')

    assert_response :not_found
    assert_not_nil assigns(:accounts)
  end

  test "business_search should search by only partial phone" do
    test_case = Business.first.phone_number[2..4]

    get :business_search, get_business_params('', test_case, '')

    assert_response :success
    assert_not_nil assigns(:businesses)
  end

  test "business_search should search by only partial company name" do
    test_case = Business.first.company_name[2..4]

    get :business_search, get_business_params(test_case)

    assert_response :success
    assert_not_nil assigns(:businesses)
  end

  test "business_search should search by only partial website" do
    test_case = Business.first.website[2..4]

    get :business_search, get_business_params('', '', test_case)

    assert_response :success
    assert_not_nil assigns(:businesses)
  end

  test "business_search should search even when no parameters" do
    get :business_search, get_business_params

    assert_response :success
    assert_not_nil assigns(:businesses)
  end

  test "business_search should search with all parameters" do
    business = Business.first
    get :business_search, get_business_params(business.company_name[1..2], business.phone_number[1.1], business.website[0..2])

    assert_response :success
    assert_not_nil assigns(:businesses)
  end

  test "business_search no data should return error" do
    get :business_search, get_business_params('asda4adasd')

    assert_response :not_found
    assert_not_nil assigns(:businesses)
  end
  private
    def get_account_params(first_name='', last_name='', email='')
      return {
          first_name: first_name, last_name: last_name, email: email
      }
    end

    def get_business_params(company_name='', phone_number='', website='')
      return {
          company_name: company_name, phone_number: phone_number, website: website
      }
    end
end
