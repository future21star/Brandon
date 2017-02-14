require 'test_helper'

class UsersLocationTest < BaseModelTest
  def new
    return UsersLocation.new
  end

  test "user expected to be set" do
    instance = new
    has_key(instance, :user)
    instance.user = User.first
    not_has_key instance, :user
  end

  test "location expected to be set" do
    instance = new
    has_key(instance, :location)
    instance.location = Location.first
    not_has_key instance, :location
  end
end
