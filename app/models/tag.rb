class Tag < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { scope: :user_id }

  has_many :jokes, through: :joke_tags
  belongs_to :user

  # Do all the tags already exist in the database?
  def exists?(tags)
  	tags.all?{|tag| Tag.find_by(name: tag) }
  end

end
