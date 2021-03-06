class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token # tokens are for the class
  # Represents people user is following
  has_many :microposts, dependent: :destroy
  has_many :active_relationships,  class_name:  "Relationship", # has many relationship tables, known to user as active_relationship
                                   foreign_key: "follower_id",  # and is known to that table as a follower_id if user is following a user
                                   dependent:   :destroy        # this relationship table represents the people you are following
  # Represents followers for a user
  has_many :passive_relationships, class_name:  "Relationship", 
                                   foreign_key: "followed_id",  # a user is known to a passive relationship table as a followed_id
                                   dependent:   :destroy
  # Names/renames followed/follower             
  has_many :following, through: :active_relationships,  source: :followed # gives us user.following, which looks for who the user has followed(_id)
  has_many :followers, through: :passive_relationships, source: :follower # gives us user.followers, which looks for follower(_id)s of this user...
  
  before_save   :downcase_email
  before_create :create_activation_digest # digest is stored in the database

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates(:name, presence: true, length:{ maximum: 50 }) # parentheses not necessary
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true  # (upon user creation, i think this is for testing iirc)


  # DEFINITIONS

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
    # selects all users this user is following
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id" 
    # subselect, so we don't pull out the entire database 14.47
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id) # L 14.44
  end

  # Add a user to following AR Association, which acts like an array
  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
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
