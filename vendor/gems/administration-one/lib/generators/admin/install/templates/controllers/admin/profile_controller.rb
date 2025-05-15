class Admin::ProfileController < Admin::BaseController
  before_action :set_user, only: %i[ show edit update ]

  def show
  end

  def edit
  end

  def update
    if @user.update params.require(:user).permit(:username, :email_address, :password, :password_confirmation)
      redirect_to admin_profile_path, notice: "Profile has been updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = Current.user
  end
end
