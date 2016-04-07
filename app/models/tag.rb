class Tag < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :user_id

  has_many :jokes, through: :joke_tags
  belongs_to :user
end
