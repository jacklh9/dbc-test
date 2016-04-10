class Joke < ActiveRecord::Base
  validates :content, :joke_hash, {presence: true, uniqueness: true}

  has_many :joke_tags
  has_many :tags, through: :joke_tags
  has_many :user_jokes
  has_many :users, through: :user_jokes

  MAX_HASH_LENGTH = 20

  # Returns joke object if joke already exists or
  # add was successful.
  def self.add_joke(content)
    joke_hash = Joke.generate_hash(content)
    existing_joke = Joke.find_by(joke_hash: joke_hash)
    if existing_joke
      existing_joke
    else
      Joke.create(content: content, joke_hash: joke_hash)
    end
  end

  # Given a collection of tag names, associates
  # those in the database with the joke.
  # Returns true if successful, false any failures
  def add_missing_tags({tags: tag_names, tag_type: tag_type})
    if tag_names
      tag_names.each do |tag_name|
        # begin
          tag = Tag.find_or_create_by(name: tag_name, tag_type: tag_type)
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
            puts "SUCCESS: tag '#{tag}' already associated to joke_id #{self.id}"
            true
          end
      end # tag_names.each
    end
  end

  def self.generate_hash(content)
    md5 = Digest::MD5.new
    md5 << "#{content}"
  	joke_hash = md5.hexdigest 
    joke_hash[0..MAX_HASH_LENGTH]
  end

  def self.get_jokes(tag_names)
    jokes = Joke.joins(:tags).where(tags: { name: tag_names })
    (jokes.size > 0) ? jokes : nil
  end

  def self.get_random_joke(tag_names)
    # OR
    # tags = Tag.where(name: tag_names)
    # jokes = tags.map{|tag| tag.jokes }.flatten

    # OR
    jokes = Joke.joins(:tags).where(tags: { name: tag_names })
  	(jokes.size > 0) ? jokes.sample : nil
  end

  def self.query_api({keyword_names: keyword_names, category_names: category_names})
      # Joke API defined in environment.rb
      url = API_URL
      url += "&keywords=#{keyword_names}&numJokes=#{MAX_JOKES}&minRating=#{MIN_JOKE_RATING}"
      # Optional
      if !category_names.blank?
        url += "category=#{category_names}"
      end

      # Query Joke API, create hash and add jokes
      puts "CONTACTING URL: #{url}"
      puts "USING KEY: #{API_KEY}"

      response = Unirest.get url,
        headers:{
         "X-Mashape-Key" => API_KEY,
         "Accept" => "application/json"
        }
  end

  def self.search_joke(args)
    keyword_names_dirty = args[:keyword_names]
    if keyword_names_dirty.blank?
      status 422
      errors << "Keywords field is a required field."
    else
      # Data cleanse
      keywords = Tag.clean_tags_array(keyword_names_dirty)
      keyword_names = Tag.tags_list(keywords)
      categories = Tag.clean_tags_array(category_names_dirty)
      category_names = Tag.tags_list(categories)
      tag_names = keyword_names
      tag_names.concat(category_names)

      if Tag.queried_by_past_users?(tag_names)
        @joke = Joke.get_random_joke(tag_names)
      else
        api_response = Joke.query_API(keyword_names: keyword_names, category_names: category_names)

        if api_response
          joke_collection = api_response.body
          puts "JOKE_COLLECTION: #{joke_collection}"
          joke_collection.each do |joke_data|
          puts "JOKE DATA: #{joke_data}"
          tag_names.concat(Tag.clean_tags_array(joke_data["category"])) # Add API's own categories to our database of tags
          tag_names.uniq!  # Remove duplicates introduced
          puts "TAGS: #{tag_names}"

          joke_object = Joke.add_joke(joke_data["joke"])
          if joke_object.valid? && joke_object.add_missing_tags({tags: keywords_list, tag_type: 'user_queried'}) && joke_object.add_missing_tags({tags: categories_list, tag_type: 'api_result'}))
            @joke = Joke.get_random_joke(tag_names)
          else
            status 500
            halt '500'
          end
        end # end joke_data
      else
        status 503
        @errors << "Service Unavailable"
      end
    end
  end

end
