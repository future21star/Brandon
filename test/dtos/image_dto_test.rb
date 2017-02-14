require 'test_helper'

class ImageDTOTest < BaseModelTest
  test "Create DTO from picture should be as expected" do
    instance = create_cooked_picture
    instance.save

    imageDTO = ImageDTO.instance_to_hash(instance)
    assert_not_nil imageDTO
    assert_not_nil imageDTO[:file_name]
    assert_equal "tiger.jpg", imageDTO[:file_name]
    assert_not_nil imageDTO[:generated_name]
    assert_not_nil imageDTO[:thumbnail_url]
    assert_not_nil imageDTO[:url]
  end
end
