class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one_attached :avatar, service: :avatars_local_storage
  after_create -> { AttachAvatarToUserJob.perform_later(user: self) }
  after_update :reattach_avatar_to_user

  validates :username,
             length: { minimum: 1, maximum: 255 },
             format: { with: /\A([A-Za-z0-9\-\_\.\s]+)+\z/ },
             uniqueness: true

  validates :email_address,
             presence: true, length: { maximum: 255 },
             format: { with: URI::MailTo::EMAIL_REGEXP },
             uniqueness: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def self.ransackable_attributes(auth_object = nil)
    %w[email_address created_at is_admin]
  end

  private

  def reattach_avatar_to_user
    if saved_change_to_attribute?(:username)
    self.avatar.purge
    AttachAvatarToUserJob.perform_now(user: self)
      self.avatar.purge
      AttachAvatarToUserJob.perform_later(user: self)
    end
  end
end
