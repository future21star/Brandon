require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test "instance should be read only, no update" do
    instance = Role.first
    instance.name = "no"
    assert_raise do ReadOnlyRecord
    instance.save!
    end
  end

  test "instance should be read only, no save" do
    instance = Role.new(:name => 'no')
    assert_raise do ReadOnlyRecord
    instance.save!
    end
  end
end
