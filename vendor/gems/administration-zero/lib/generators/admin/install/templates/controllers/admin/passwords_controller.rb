class Admin::PasswordsController < Admin::BaseController
  skip_before_action :authenticate_as_admin
  before_action :set_user_by_token, only: %i[ edit update ]

  layout "admin/authentication"

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  private
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: "Password reset link is invalid or has expired."
    end
end
