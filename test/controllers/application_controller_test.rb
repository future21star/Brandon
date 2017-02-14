require 'test_helper'

class ApplicationControllerTest < BaseControllerTest
  setup do
    @controller = ApplicationController.new
  end

  test "errors_to_hash should return expected format" do
    user = User.new
    user.valid?
    hash = @controller.errors_to_hash user
    assert hash
    msg = "can't be blank"
    assert_equal msg, hash[:email]
    assert_equal msg, hash[:password]
    assert_equal msg, hash[:address]
  end

  test "errors_to_hash when multiple field errors should only put base message in once" do
    address = Address.new
    address.save

    hash = @controller.errors_to_hash(address)
    assert_not_nil hash
    assert_not_same 0, hash.size
    base_errors = hash[:base]
    assert_not_nil base_errors
    assert_not_same 0, base_errors.size
    found = false
    base_errors.each { |error|
      if BASE_FIELD_ERROR_TEXT.eql?(error)
        if !found
        found = true
        else
          fail("Found the base error message multiple times")
        end
      end
    }
    unless found
      fail("Failed to find base error")
    end
  end

  test "errors_to_hash when no field errors should not put field error message in" do
    class NeverHappyAddress < Address
      def validate
        self.errors.add(:base, 'I will never pass');
      end
    end
    address = NeverHappyAddress.new
    address.save

    hash = @controller.errors_to_hash(address)
    assert_not_nil hash
    assert_not_same 0, hash.size
    base_errors = hash[:base]
    assert_not_nil base_errors
    assert_not_same 0, base_errors.size
    found = false
    base_errors.each { |error|
      if BASE_FIELD_ERROR_TEXT.eql?(error)
        if !found
        found = true
        else
          fail("Found the base error message multiple times")
        end
      end
    }
    unless found
      fail("Failed to find base error")
    end
  end

  test "errors_to_hash when nested with parse should show all root fields" do
    def custom_parser(key)
      return @controller.simple_error_nest_scrubber(key, ['address'])
    end

    user = create_cooked_user
    user.last_name = nil
    user.address.street_name = nil
    user.save
    hash = @controller.errors_to_hash(user, method(:custom_parser))
    assert_not_nil hash
    assert_not_same 0, hash.size
    assert hash[:last_name]
    assert_not_nil hash[:last_name]
    assert hash[:street_name]
    assert_not_nil hash[:street_name]
  end
end
