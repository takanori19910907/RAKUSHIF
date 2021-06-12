require 'test_helper'

class Api::V1::Admin::FixedShiftsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_v1_admin_fixed_shifts_create_url
    assert_response :success
  end

end
