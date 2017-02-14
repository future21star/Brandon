require 'test_helper'

class AddressesSecurityControllerTest < BaseControllerTest
  setup do
    @controller = AddressesController.new
  end

  test "show should only be accessible to expected roles" do
    run_role_get_security(:show, {id: Address.first.id, format: :json}, ROLE_USER)
  end

  test "update should only be accessible to expected roles" do
    address = Address.first
    args = address_update_json
    args[:id] = address.id
    args[:format] = :json
    run_role_patch_security(:update, args, ROLE_USER)
  end
end
