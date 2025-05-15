ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)

  fixtures :all

  def sign_in_as_admin_user(user)
    post admin_sign_in_url, params: {
      email_address: user.email_address,
      password: "Password1234"
    }
    user
  end

  def sign_in_as(user)
    post session_path, params: {
      email_address: user.email_address,
      password: "Password1234"
  }
    user
  end
end
