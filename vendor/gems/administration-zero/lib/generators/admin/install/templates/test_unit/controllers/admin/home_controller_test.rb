require "test_helper"

class Admin::HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as_admin_user users(:admin)
  end

  test "should get index" do
    get admin_root_url
    assert_response :success
  end
end
