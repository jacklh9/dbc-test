class User < ActiveRecord::Base

  validates :name, presence: true
  validates :email, {presence: true, uniqueness: true}
  validates :password_hash, presence: true

  has_many :user_jokes
  has_many :joke_tags
  has_many :favorite_jokes, through: :user_jokes, source: :joke
  has_many :tags

  MIN_PASSWORD_LENGTH = 8

  def password
    @password ||= BCrypt::Password.new(self.password_hash)
  end

  def password=(new_plain_text_password)
    @password = BCrypt::Password.create(new_plain_text_password)
    self.password_hash = @password
  end

  def authenticate(plain_text_password)
    self.password == plain_text_password
  end

  def self.min_passwd_length?(plain_text_password)
    plain_text_password.length >= MIN_PASSWORD_LENGTH
  end

  def has_this_favorite?(joke)
    self.favorite_jokes.include? joke
  end

end



