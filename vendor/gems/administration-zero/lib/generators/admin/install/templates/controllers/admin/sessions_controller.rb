class Admin::SessionsController < Admin::BaseController
  skip_before_action :authenticate_as_admin, except: :destroy
  rate_limit to: 5, within: 10.minutes, only: :create, with: -> { redirect_to admin_sign_in_path, alert: "Try again later." }

  layout "admin/authentication"

  def new
  end

  def create
    user = User.authenticate_by(params.permit(:email_address, :password))
    if user && user.is_admin?
      start_new_session_for user
      redirect_to admin_root_path, notice: "Welcome!"
    else
      redirect_to admin_sign_in_path, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session
    redirect_to admin_sign_in_path, notice: "You've been signed out."
  end
end
