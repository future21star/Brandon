require 'test_helper'

class PicturesSecurityControllerTest < BaseControllerTest
  setup do
    @controller = PicturesController.new
    @picture = create_cooked_picture
    save @picture
  end

  def validate_redirect_to_picture(user, args, verb)
    if verb == 'delete'
      assert_redirected_to pictures_path
    else
      assert_redirected_to picture_path(@picture.id)
    end
  end

  test "create should only be accessible to expected roles" do
    run_role_post_security(:create, picture_create_json)
  end

  test "destroy should only be accessible to expected roles" do
    run_role_delete_security(:destroy, {id: @picture}, ROLE_USER, method(:validate_redirect_to_picture))
  end

  test "index should only be accessible to expected roles" do
    run_role_get_security(:index, ROLE_USER, method(:validate_redirect_to_picture))
  end

  test "new should only be accessible to expected roles" do
    run_role_get_security(:index, ROLE_USER, method(:validate_redirect_to_picture))
  end
end
