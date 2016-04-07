class UserJoke < ActiveRecord::Base
  validates :user_id, {presence: true, uniqueness: { scope: :joke_id} }
  validates :joke_id, presence: true

  belongs_to :users
  belongs_to :jokes
end
