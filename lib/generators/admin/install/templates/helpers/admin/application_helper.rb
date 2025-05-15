require "pagy/extras/bootstrap"

module Admin::ApplicationHelper
  include Pagy::Frontend

  def title
    content_for(:title) || Rails.application.class.to_s.split("::").first
  end

  def active_nav_item(*names)
    names.include?(controller_path) ? "active" : ""
  end

  def true_or_false_icon(statement)
    if statement == true
      '<span class="true"><svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-check"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M5 12l5 5l10 -10" /></svg></span>'.html_safe
    else
      '<span class="false"><svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-x"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M18 6l-12 12" /><path d="M6 6l12 12" /></svg></span>'.html_safe
    end
  end

  def path_to_avatar(user)
    user.avatar.attached? ? rails_blob_path(user.avatar, only_path: true) : "admin/default_avatar.png"
  end
end
