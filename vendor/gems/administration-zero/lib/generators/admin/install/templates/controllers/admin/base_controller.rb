class Admin::BaseController < ActionController::Base
  include Authentication
  include Pagy::Backend

  skip_before_action :require_authentication
  before_action :authenticate_as_admin
  around_action :set_time_zone

  private
    def set_time_zone
      Time.use_zone(cookies[:time_zone]) { yield }
    end

    def authenticate_as_admin
      resume_session
      unless Current.user && Current.user.is_admin?
        redirect_to admin_sign_in_path, notice: "Insufficient permissions for this action."
      end
    end
end
