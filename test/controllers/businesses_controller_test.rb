require 'test_helper'

class BusinessesControllerTest < BaseControllerTest

  setup do
    business_sign_in
  end

  test "create should create" do
    user_sign_in
    args = business_create_json
    args[:format] = :json
    assert_difference('Business.count') do
      post :create, args
    end
    assert_response :created
  end

  test "create_tag should create" do
    assert_difference('BusinessTag.count') do
      post :create_tag, {tag: {id: Tag.first.id}}
    end
    assert_response :created
  end

  test "create_tag with tag that does not exist should return unprocessable_entity" do
    assert_no_difference('BusinessTag.count') do
      post :create_tag, {tag: {id: -1}}
    end
    assert_response :unprocessable_entity
  end

  test "destroy_tag should destroy tag" do
    business = get_business.business
    pre_count = business.tags.size
    tag = business.tags[0]
    assert_not_nil tag

    delete :destroy_tag, {tag: {id: tag.id}}
    assert_response :no_content

    business.reload
    assert_equal pre_count - 1, business.tags.size
  end

  test "destroy_tag when non-existent should return not_found" do
    business = get_business.business
    tag = business.tags[0]
    tag = Tag.where.not(id: tag.id).first
    assert_not_nil tag

    delete :destroy_tag, {tag: {id: tag.id}}
    assert_response :not_found

    tag.reload
    assert_not_nil tag
    assert_not_nil tag.id
  end

  test "update should update fields" do
    business = get_business.business

    new_name = "new_name"
    website = "aaaaa.com"
    phone = "5198229233"
    biography = "This is a new bio and it sucks really bad"

    args = business_update_json(new_name, phone, website, biography)
    args[:id] = business.id
    patch :update, args
    assert_response :ok

    business.reload
    assert_equal new_name, business.company_name
    assert_equal 'http://' + website, business.website
    assert_equal '1' + phone, business.phone_number
    assert_equal biography, business.biography
  end


  private

end
