require 'test_helper'


class UserTest <  BaseModelTest
  def new
    return User.new
  end

  test "email expected to be set" do
    instance = new
    has_key(instance, :email)
    instance.email = "t@t.com"
    not_has_key instance, :email
  end

  test "first_name expected to be set" do
    instance = new
    has_key(instance, :first_name)
    instance.first_name = "t@t.com"
    not_has_key instance, :first_name
  end

  test "last_name expected to be set" do
    instance = new
    has_key(instance, :last_name)
    instance.last_name = "t@t.com"
    not_has_key instance, :last_name
  end

  test "address expected to be set" do
    instance = new
    has_key(instance, :address)
    instance.address = Address.first
    not_has_key instance, :address
  end

  test "business expected to be validated when set" do
    instance = new
    instance.business = Business.new
    has_key(instance, :business)
    instance.business = create_cooked_business
    instance.valid?
    not_has_key instance, :business
  end

  test "password expected to be set" do
    password = PASSWORD
    instance = new
    has_key(instance, :password)
    instance.password = password
    not_has_key instance, :password
  end

  test "invalid email formats should be invalid" do
    instance = new
    emails = ["t", "t.", "t.t.com", "t@t", "t@.com", "t@.com", "@t.com"]
    emails.each { |email|
      instance.email = email
      has_key instance, :email
    }
  end

  test "valid email formats should be valid" do
    instance = new
    emails = ["t@t.com", "32brandon@t.com", "bra2d@t.com", "brandon.bd@t.com"]
    emails.each { |email|
      instance.email = email
      not_has_key instance, :email
    }
  end

  test "user has admin role should result in true" do
    instance = users(:one)
    assert instance.has_role(ROLE_ADMIN)
  end

  test "user has user role should result in true" do
    instance = User.last
    assert instance.has_role(ROLE_USER)
  end

  test "admin user has user and admin role should result in true" do
    instance = users(:one)
    assert instance.has_role(ROLE_ADMIN)
    assert instance.has_role(ROLE_USER)
  end

  test "emails should be upper case" do
    instance = new
    expected = "test_again@tester.com"
    test_cases = ["Test_AGain@teSter.com", "test_AGAIN@testER.COM", " " + expected, expected.upcase]
    test_cases.each { |test_case|
      instance.email = test_case
      instance.clean_input!
      assert_equal expected, instance.email, "Test case: #{test_case}"
    }
  end

  test "validate first_name bounds enforced" do
    test_cases = ["s", STRING_255, STRING_256]
    expectations = [true, true, false]
    user = create_cooked_user
    user.save
    user = User.find_by_id user.id
    validate_bounds user, :first_name, test_cases, expectations
  end

  test "validate last_name bounds enforced" do
    test_cases = ["s", STRING_255, STRING_256]
    expectations = [true, true, false]
    user = create_cooked_user
    user.save
    user = User.find_by_id user.id
    validate_bounds user, :last_name, test_cases, expectations
  end

  test "create user with opt_in should create preferences" do
    opt_in = true
    user = create_cooked_user (opt_in)
    save user

    assert_not_nil user.user_preferences
    assert user.user_preferences[0].email == opt_in
  end

  test "regular user save should create whole data structure" do
    user = create_cooked_user
    save user

    assert_equal true, user.errors.empty?
    assert user.id
    assert user.address
    assert user.address.id
    assert user.user_roles
    assert user.user_roles[0].id
    assert user.users_locations
    assert user.users_locations[0].id
    assert_not_nil user.user_preferences
    assert_equal Preference::USER_PREFERENCES.size, user.user_preferences.size
    assert !user.user_preferences[0].email
  end

  test "business user save should create whole data structure" do
    user = create_cooked_business_user
    save user

    assert_equal true, user.errors.empty?, "Errors: #{user.errors.keys}"
    assert user.id
    user = User.find_by_id user.id
    assert user.address
    assert user.address.id
    assert user.user_roles
    assert user.user_roles[0].id
    assert user.user_roles[1].id
    assert user.users_locations
    assert user.users_locations[0].id
    assert user.business
    assert user.business.id
    assert_not_nil user.user_preferences
    assert_equal Preference::BUSINESS_PREFERENCES.size + Preference::USER_PREFERENCES.size, user.user_preferences.size
  end
end
