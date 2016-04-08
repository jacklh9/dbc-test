class Tag < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { scope: :user_id }

  has_many :jokes, through: :joke_tags
  belongs_to :user

  # Given a comma-separated list of tags,
  # strips extra whitespace before, after 
  # and shrinks 2 or more spaces into one in-between multi-word tags,
  # and returns collection of lower-case tags.
  def self.clean_tags_array(tags_list)
	 # Remove white space if all spaces
  	if tags_list
  		tags_list.gsub(/^\s+$/,'')
	  	tags_list.downcase.split(',').map(&:strip).map{ |c| c.gsub(/\s{2,}/, ' ')}
	else
		Array.new
	end
  end

  # Returns a comma-separated list given a collection of tags
  def self.tags_list(tags_array)
  	if tags_array
  		tags_array.join(',')
  	else
  		""
  	end
  end

  # Do all the site-owned tags (user_id: nil) already exist in the database?
  def self.site_tags_exist?(tags)
  	tags.all?{|tag| Tag.find_by(name: tag, user_id: nil) }
  end

  # Given a collection of tag names, adds any that
  # are missing from the database.
  # Returns true if successful, false otherwise.
  def self.add_missing_tags(tag_names)
  	tag_names.all? do |name|
  		begin
	  		tag = Tag.find_or_create_by(name: name)
	  		tag.save
	  	rescue
	  		false
	  	end
	end
  end

end
