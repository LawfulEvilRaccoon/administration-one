require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as_admin_user users(:admin)
  end

  test "should get index" do
    get admin_users_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.all.count") do
      post admin_users_url, params: { user: {
        username: "Jim",
        email_address: "jimdoe@example.com",
        password: "Password1234",
        password_confirmation: "Password1234" } }
    end

    assert_redirected_to admin_user_url(User.last)
  end

  test "should show admin_user" do
    get admin_user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_user_url(@user)
    assert_response :success
  end

  test "should update admin_user" do
    patch admin_user_url(@user), params: { user: { username: "James" } }
    @user.reload

    assert_redirected_to admin_user_url(@user)
    assert @user.username == "James"
  end

  test "should destroy admin_user" do
    assert_difference("User.count", -1) do
      delete admin_user_url(@user)
    end

    assert_redirected_to admin_users_url
  end
end
