require 'test_helper'

class PurchaseSecurityControllerTest < BaseControllerTest
  setup do
    @purchase = create_cooked_purchase(get_business)
    save @purchase
    @controller = PurchasesController.new
  end

  # [:completed, :create, :index, :new]
  test "index should only by accessible to expected roles" do
    role = ROLE_BUSINESS

    run_role_get_security(:index, {}, role)
  end

  test "new should only by accessible to expected roles" do
    role = ROLE_BUSINESS

    run_role_get_security(:new, package_json, role)
  end

  test "completed should only by accessible to expected roles" do
    role = ROLE_BUSINESS

    # Because the lookup is locked down to only the right user, we must change the user
    run_role_get_security(:completed, {id: @purchase.id}, role, nil, method(:change_user))
  end

  test "show should only by accessible to expected roles" do
    role = ROLE_BUSINESS

    run_role_get_security(:show, {id: @purchase.id}, role, nil, method(:change_user))
  end

  test "create should only by accessible to expected roles" do
    skip("need to mock out stripe api")
    role = ROLE_BUSINESS

    run_role_post_security(:create, purchase_json, role)
  end

  test "list_packages should only by accessible to expected roles" do
    role = ROLE_BUSINESS

    run_role_get_security(:list_packages, {}, role)
  end

  private
    def change_user(user)
      unless user.id == @purchase.user.id
        pre = @purchase.user.id
        @purchase.user = user
        save @purchase
        assert_equal user.id, @purchase.user.id, "User id was not changed, was: #{pre} and shouldve changed to: #{user.id} but didnt"
      end
  end
end
