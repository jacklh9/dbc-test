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

  # Returns true if all the tags are nil or cached in the database either
  # by user query or API categories returned.
  def self.is_cached?(tag_names_collection)
    if tag_names_collection
      tag_names_collection.all?{|tag_name| (Tag.find_by(name: tag_name, user_id: nil)) ? true : false }
    else
      true
    end
  end

  def self.merge(a,b)
    a = (a) ? a : []
    b = (b) ? b : []
    a.concat(b).uniq
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
  def self.queried_by_past_users?(tag_names_collection)
    tag_type = TagType.find_by(name: USER_QUERY)
  	tag_names_collection.all?{|tag_name| (Tag.find_by(name: tag_name, tag_type: tag_type, user_id: nil)) ? true : false }
  end

end
