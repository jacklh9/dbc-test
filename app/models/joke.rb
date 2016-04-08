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
    # OR
    # tags = Tag.where(name: tag_names)
    # jokes = tags.map{|tag| tag.jokes }.flatten

    # OR
    jokes = Joke.joins(:tags).where(tags: { name: tag_names })
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
        # begin
          tag = Tag.find_or_create_by(name: tag_name)
          if !self.tags.include? tag
            puts "Adding tag '#{tag}' to joke_id #{self.id}"
            self.tags << tag
            puts "Shovelled tag '#{tag} to joke_id #{self.id}"
            puts "Checking if in self.tags"
            if self.tags.include? tag
              puts "SUCCESS: Adding tag '#{tag}' to joke_id #{self.id}"
              true
            else
              puts "FAIL: Adding tag '#{tag}' to joke_id #{self.id}"
              false
            end  
          else
            true
          end
        # # rescue
        #   puts "Error associating tag '#{tag}' to joke_id #{self.id}"
        #   false
        # # end # begin/rescue/end
      end # tag_names.each
    end
  end

end
