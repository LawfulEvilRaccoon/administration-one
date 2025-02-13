require "test_helper"

class Admin::ProfileControllerTest < ActionDispatch::IntegrationTest
  def setup
    sign_in_as_admin_user users(:admin)
  end

  test "should get show" do
    get admin_profile_path
    assert_response :success
  end

  test "should get edit" do
    get admin_edit_profile_path
    assert_response :success
  end

  test "should update profile" do
    @user = users(:admin)
    patch admin_profile_path params: { user: { username: "administrator" } }
    @user.reload

    assert @user.username == "administrator"
    assert_redirected_to admin_profile_path
  end
end
