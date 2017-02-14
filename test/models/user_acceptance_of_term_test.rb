require 'test_helper'

class UserAcceptanceOfTermTest < BaseModelTest
  def new
    return UserAcceptanceOfTerms.new
  end

  test "user expected to be set" do
    instance = new
    has_key(instance, :user)
    instance.user = User.first
    not_has_key instance, :user
  end

  test "terms_and_conditions expected to be set" do
    instance = new
    has_key(instance, :terms_and_conditions)
    instance.terms_and_conditions = TermsAndConditions.first
    not_has_key instance, :terms_and_conditions
  end

  test "happy path should persist" do
    instance = create_cooked_user_acceptance_of_terms
    save instance

    assert_equal true, instance.errors.empty?
    assert instance.id
  end

  test "has_user_accepted when has should return true" do
    instance = create_cooked_user_acceptance_of_terms
    save instance

    assert UserAcceptanceOfTerms.has_user_accepted?(instance.user)
  end

  test "has_user_accepted when has NOT should return false" do
    user = users(:one)
    result = UserAcceptanceOfTerms.has_user_accepted?(user)
    assert !result
  end
end
