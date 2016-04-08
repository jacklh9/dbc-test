class Joke < ActiveRecord::Base
  validates :content, :joke_hash, {presence: true, uniqueness: true}

  has_many :joke_tags
  has_many :tags, through: :joke_tags
  has_many :user_jokes
  has_many :users, through: :user_jokes

  MAX_HASH_LENGTH = 20

  def self.generate_hash(content)
    md5 = Digest::MD5.new
    md5 << "#{content}"
  	joke_hash = md5.hexdigest 
    joke_hash[0..MAX_HASH_LENGTH]
  end

  def self.get_random_joke(tag_names)
    tags = Tag.where(name: tag_names)
    jokes = tags.map{|tag| tag.jokes }.flatten
  	(jokes.size > 0) ? jokes.sample : nil
  end

  # Returns joke object if joke already exists or
  # add was successful.
  def self.add_joke(content)
  	joke_hash = Joke.generate_hash(content)
  	existing_joke = Joke.find_by(joke_hash: joke_hash)
  	if existing_joke
  		return existing_joke
  	else
  		Joke.create(content: content, joke_hash: joke_hash)
  	end
  end

  # Given a collection of tag names, associates
  # those in the database with the joke.
  # Returns true if successful, false any failures
  def add_missing_tags(tag_names)
    if tag_names
      tag_names.each do |tag_name|
        begin
          tag = Tag.find_or_create_by(name: "#{tag_name}")
          if !self.tags.include? tag
            self.tags << tag
            self.save
          else
            true
          end
        rescue
          false
        end
      end
    end
  end

end
