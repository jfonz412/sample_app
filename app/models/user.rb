class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id", #Relationship refers to user as follower_id
                                  dependent:   :destroy       #if user destroyed, destroy relationships
  attr_accessor :remember_token, :activation_token, :reset_token # tokens are for the class
  before_save   :downcase_email
  before_create :create_activation_digest # digest is stored in the database

	validates(:name, presence: true, length:{ maximum: 50 }) # parentheses not necessary
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  # passwords are allowed to be nil for the this line, but not for the above method
  # (upon user creation)
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns the hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # returns a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest
  def authenticated?(attribute, token) # digest/ token
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the passwiord reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Defines a proto-feed
  # See "Following users" for the full implementation
  # ? can be subsituted for id, but would cause a major security hole 
  def feed
    Micropost.where("user_id = ?", id) # pulls all posts of this user via id
  end

  private

    def downcase_email
      self.email.downcase!
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
