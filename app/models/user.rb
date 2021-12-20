class User < ApplicationRecord
  attr_accessor :remember_token
  before_save{email.downcase!}
  validates :name, presence: {message: :presence_message},
    length: {maximum: Settings.length.max_50}
  validates :email, presence: true, length: {maximum: Settings.length.max_255},
    format: {with: Settings.format.VALID_EMAIL_REGEX}, uniqueness: true
  has_secure_password
  validates :password, :password_confirmation, presence: true,
    length: {minimum: Settings.length.min_6}
  def self.digest string
    cost =  if ActiveModel::SecurePassword.min_cost
              BCrypt::Engine::MIN_COST
            else
              BCrypt::Engine.cost
            end
    BCrypt::Password.create string, cost: cost
  end

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember_me
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_column :remember_digest, nil
  end
end
