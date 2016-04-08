class JokeTag < ActiveRecord::Base
  validates :joke_id, {presence: true, uniqueness: { scope: [:tag_id, :user_id] } }
  validates :tag_id, presence: true
  validates :user_id, uniqueness: true

  belongs_to :tag
  belongs_to :joke
end
