require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:admin)
  end

  test "valid usernames" do
    usernames = %w[ John Gorlock_The_Destroyer Stalin-3000 Max.Pain ]
    usernames.each do |u|
      @user.username = u
      assert @user.valid?
    end
  end

  test "invalid usernames" do
    usernames = %w[ 松本行弘 $uperM@n_2025 Поручик_Ржевский ]
    usernames.append ("a" * 256)
    usernames.each do |u|
      @user.username = u
      assert_not @user.valid?
    end
  end

  test "username should be uniq" do
    @user.username = "Jane Doe"
    assert_not @user.valid?
  end

  test "email should be uniq" do
    @user.email_address = "guest@example.com"
    assert_not @user.valid?
  end
end
