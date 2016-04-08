class Joke < ActiveRecord::Base
  validates :content, :joke_hash, presence: true

  has_many :tags, through: :joke_tags
  has_many :users, through: :user_jokes

  MAX_HASH_LENGTH = 50

  def hash
  	self.joke_hash
  end

  def hash=(joke)
    self.joke_hash = Digest::MD5.new(joke)[0..MAX_HASH_LENGTH]
  end

end
