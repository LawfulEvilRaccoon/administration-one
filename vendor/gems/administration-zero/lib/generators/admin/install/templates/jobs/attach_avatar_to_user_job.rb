require "open-uri"
class AttachAvatarToUserJob < ApplicationJob
  queue_as :default
  
  def perform(**args)
    user = args[:user]
    size = 512
    colors = %w[ 066fd1 ]

    unless user.nil?
      seed = URI.encode_uri_component user.username
      url = "https://api.dicebear.com/9.x/initials/png?size=#{size}&seed=#{seed}&backgroundColor=#{colors.sample}&scale=120"

      begin
        user.avatar.attach(io: OpenURI.open_uri(url), filename: "#{user.id}_avatar.png") unless user.avatar.attached?
      rescue
        AttachAvatarToUserJob.set(wait: 1.minutes).perform_later(user: user)
      end
    end
  end
end