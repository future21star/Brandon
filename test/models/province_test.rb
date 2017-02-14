require 'test_helper'

class ProvinceTest < ActiveSupport::TestCase

  test "province should be read only, no update" do
    province = Province.first
    province.code = "no"
    assert_raise do ReadOnlyRecord
    province.save!
    end
  end

  test "province should be read only, no save" do
    province = Province.new(:code => 'no', :name=> 'bad', :country => Country.first)
    assert_raise do ReadOnlyRecord
    province.save!
    end
  end
end
