class Joke < ActiveRecord::Base
  validates :content, presence: true

  has_many :tags, through: :joke_tags
  has_many :users, through: :user_jokes
end
