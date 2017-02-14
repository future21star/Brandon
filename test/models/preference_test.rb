require 'test_helper'

class PreferenceTest < BaseModelTest
  def new
    return Preference.new
  end

  test "name expected to be set" do
    instance = new
    has_key(instance, :name)
    instance.name = "test"
    not_has_key instance, :name
  end
end
