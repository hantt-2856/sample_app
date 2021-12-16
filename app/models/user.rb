class User < ApplicationRecord
  before_save{email.downcase!}
  validates :name, presence: {message: :presence_message},
    length: {maximum: Settings.length.max_50}
  validates :email, presence: true, length: {maximum: Settings.length.max_255},
    format: {with: Settings.format.VALID_EMAIL_REGEX}, uniqueness: true
  has_secure_password
  validates :password, :password_confirmation, presence: true,
    length: {minimum: Settings.length.min_6}
end
