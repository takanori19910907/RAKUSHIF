require 'test_helper'

class Api::V1::Staff::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_staff_users_index_url
    assert_response :success
  end

end
