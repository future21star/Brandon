require 'test_helper'


class BusinessTest < BaseModelTest
  def new
    return Business.new
  end

  test "Company and Phone must be set" do
    business = new
    has_key(business, :company_name)
    has_key(business, :phone_number)
    assert_not business.valid?
    business.company_name = "Test"
    assert_not business.valid?
    has_key(business, :phone_number)
    business.phone_number = "15194965896"
    not_has_key(business, :company_name)
    not_has_key(business, :phone_number)
    assert_not business.valid?
  end

  test "website is not required if blank" do
    run_required_if_set_tests :website
  end

  test "Invalid URLs should not be accepted" do
    instance = new
    urls = ["11.1com"]

    urls.each { |url|
      instance.website = url
      has_key instance, :website
    }
  end

  test "Proper URLs should be accepted" do
    instance = new
    urls = ["http://google.com",  "http://google.com/", "http://www.google.com",
            "https://google.com", "google.com", "www.google.com", "google.com/", "HttPs://google.com",
    "//google.com", "://google.com"]

    urls.each { |url|
      instance.website = url
      not_has_key instance, :website
    }
  end

  test "user expected to be set" do
    instance = new
    has_key(instance, :user)
    instance.user = create_cooked_user
    not_has_key instance, :user
  end

  test "business_tags expected to be set" do
    instance = new
    has_key(instance, :business_tags)
    instance.business_tags << BusinessTag.first
    not_has_key instance, :business_tags
  end

  test "phone numbers should only be numeric" do
    instance = new
    number = "5194965896"
    test_cases = ["1" + number, number, "+1" + number, "+" + number, "(519) 496-5896"]
    test_cases.each { |test_case|
      instance.phone_number = test_case
      instance.clean_input!
      assert_equal "1" + number, instance.phone_number, "Test case: #{test_case}"
    }
  end

  test "validate company_name bounds enforced" do
    test_cases = ["sa", STRING_255, STRING_256]
    expectations = [true, true, false]
    user = create_cooked_business_user
    user.save
    user = User.find_by_id user.id
    validate_bounds user.business, :company_name, test_cases, expectations
  end

  test "validate website bounds enforced" do
    test_cases = ["s.com", create_string(244) + ".com", create_string(244)+".comx"]
    expectations = [true, true, false]
    user = create_cooked_business_user
    save user
    user = User.find_by_id user.id
    validate_bounds user.business, :website, test_cases, expectations
  end

  test "validate phone_number bounds enforced" do
    test_cases = [5194965896, 15194965896, 1519496589612345]
    expectations = [true, true, false]
    user = create_cooked_business_user
    user.save
    user = User.find_by_id user.id
    validate_bounds user.business, :phone_number, test_cases, expectations
  end

  test "When submitting a business, the whole data structure should be saved" do
    business = create_cooked_business
    save business

    assert_equal true, business.errors.empty?
    assert business.id
    assert business.user.id
    assert business.user.address
    assert business.user.address.id
    assert business.user.user_roles
    assert business.user.user_roles[0].id
    assert business.user.user_roles[1].id
    assert business.user.users_locations
    assert business.user.users_locations[0].id
    assert business.business_tags[0].id
  end

  test "search when null websites should still return" do
    business = create_cooked_business
    business.website = nil
    save business

    results = Business.search(business.company_name, business.phone_number, business.website)
    assert_not_nil results
    assert_equal 1, results.size
    assert_not_nil results[0]
    assert_equal business.id, results[0].id
  end

  test "search when null websites but passed in website should not return" do
    business = create_cooked_business
    business.website = nil
    save business

    results = Business.search(business.company_name, business.phone_number, ".ca")
    assert_not_nil results
    assert_equal 0, results.size
  end

  test "create business with opt_in should create preferences" do
    opt_in = true
    user = create_cooked_user(opt_in)
    save user
    user.reload
    business = create_cooked_business(user, "http://ss.com", opt_in)
    save business

    user.reload
    user.user_preferences.reload

    assert_not_nil user.user_preferences
    user.user_preferences.each { |pref|
      assert pref.email == opt_in
    }
  end
end
