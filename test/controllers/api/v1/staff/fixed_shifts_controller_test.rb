require 'test_helper'

class Api::V1::Staff::FixedShiftsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_staff_fixed_shifts_index_url
    assert_response :success
  end

end
