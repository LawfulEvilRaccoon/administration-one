require "test_helper"

class Admin::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin)
  end

  test "should get new" do
    get admin_sign_in_url
    assert_response :success
  end

  test "should sign in" do
    post admin_sign_in_url, params: { email_address: @user.email_address, password: "Password1234" }
    assert_redirected_to admin_root_url

    get admin_root_url
    assert_response :success
  end

  test "should not sign in with wrong credentials" do
    post admin_sign_in_url, params: { email_address: @user.email_address, password: "Incorect4321" }
    assert_redirected_to admin_sign_in_url
    assert_equal "Try another email address or password.", flash[:notice]

    get admin_root_url
    assert_redirected_to admin_sign_in_url
  end

  test "should sign out" do
    sign_in_as_admin_user users(:admin)

    post admin_sign_out_url
    assert_redirected_to admin_sign_in_url
  end
end
