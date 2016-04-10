class Tag < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { scope: :user_id }

  has_many :joke_tags
  has_many :jokes, through: :joke_tags
  belongs_to :user
  belongs_to :tag_type

  # Given a comma-separated list of tags,
  # strips extra whitespace before, after 
  # and shrinks 2 or more spaces into one space in-between multi-word tags,
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

  # Have all the site-owned tags (user_id: nil) already been explicitly queried 
  # by a user in the past and therefore the max results have already 
  # been returned before and thus already exist in the database?
  def self.queried_by_past_users?(tag_names)
  	tag_names.all?{|tag| Tag.find_by(name: tag, tag_type: 'user_query', user_id: nil) }
  end

end
