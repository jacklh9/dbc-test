class Tag < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { scope: :user_id }

  has_many :jokes, through: :joke_tags
  belongs_to :user

  # Given a comma-separated list of tags,
  # strips extra whitespace before, after 
  # and shrinks 2 or more spaces into one in-between multi-word tags,
  # and returns collection of lower-case tags.
  def clean_tags_array(tags_list)
  	tags_list.downcase.split(',').map(&:strip).map{ |c| c.gsub(/\s{2,}/, ' ')}
  end

  # Returns a comma-separated list given a collection of tags
  def tags_list(tags_array)
  	tags_array.join(',')
  end

  # Do all the site-owned tags (user_id: nil) already exist in the database?
  def site_tags_exist?(tags)
  	tags.all?{|tag| Tag.find_by(name: tag, user_id: nil) }
  end

  # Given a collection of tags, adds any that
  # are missing from the database.
  # Returns true if successful, false otherwise.
  def add_missing_tags(tags)
  	tags.all? do |tag|
  		begin
	  		(Tag.find_or_create_by(name: tag)) ? true
	  	rescue
	  		false
	  	end
  end

end
