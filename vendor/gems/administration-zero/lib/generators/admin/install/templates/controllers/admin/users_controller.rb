class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    @search = User.all.ransack(params[:q])

    respond_to do |format|
      format.html { @pagy, @users = pagy(@search.result) }
      format.csv  { render csv: @search.result }
    end
  end

  def show
  end

  def new
    @user = User.where(is_admin: true).new
  end

  def edit
  end

  def create
    @user = User.where(is_admin: true).new(user_params)

    if @user.save
      redirect_to admin_user_path(@user), notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "User was successfully destroyed."
  end

  private
    def set_user
      @user = User.find_by(id: params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :email_address, :password, :password_confirmation, :is_admin)
    end
end
