require 'test_helper'

class SpamReportTest <  BaseModelTest
  def new
    return SpamReport.new
  end

  test "Save project spam should persist as expected" do
    target_id = 1
    instance = SpamReport.report_project nil, target_id

    assert instance.id
    assert_equal target_id, instance.target_id
    assert_equal PROJECT, instance.target_type
  end
end
