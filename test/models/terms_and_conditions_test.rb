require 'test_helper'

class TermsAndConditionsTest < BaseModelTest
  def new
    return TermsAndConditions.new
  end

  test "latest should return latest version" do
    instance = TermsAndConditions.first
    assert_not_nil instance
    assert_nil instance.inactivated_at

    result = TermsAndConditions.latest
    assert_not_nil result
    assert_equal instance.id, result.id
  end

  test "latest when multiple should return latest non-inactivated version" do
    class Temp < TermsAndConditions
      def readonly?
        false
      end
    end

    first = Temp.first
    assert_not_nil first
    first.inactivated_at = Time.now.utc
    assert_not_nil first.inactivated_at
    save first

    result = TermsAndConditions.latest
    assert_nil result

    new = Temp.new(:eula => 'New EULA',)
    save new
    assert_not_nil new
    assert_nil new.inactivated_at

    result = TermsAndConditions.latest
    assert_not_nil result
    assert_equal new.id, result.id
  end
end
