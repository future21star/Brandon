require 'test_helper'

class UserRoleTest < BaseModelTest
  def new
    return UserRole.new
  end

  test "user expected to be set" do
    instance = new
    has_key(instance, :user)
    instance.user = User.first
    not_has_key instance, :user
  end

  test "role expected to be set" do
    instance = new
    instance.role_id = nil
    has_key(instance, :role)
    instance.role = Role.first
    not_has_key instance, :role
  end
end
