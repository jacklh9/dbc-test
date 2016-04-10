class Joke < ActiveRecord::Base
  validates :content, :joke_hash, {presence: true, uniqueness: true}

  has_many :joke_tags
  has_many :tags, through: :joke_tags
  has_many :user_jokes
  has_many :users, through: :user_jokes

  MAX_HASH_LENGTH = 20

  attr_accessor :errors

  # Returns joke object if joke already exists or
  # add was successful.
  def self.add_joke(content)
    joke_hash = Joke.generate_hash(content)
    existing_joke = Joke.find_by(joke_hash: joke_hash)
    (existing_joke) ? existing_joke : Joke.create(content: content, joke_hash: joke_hash)
  end

  # Given a collection of tag names, associates
  # those in the database with the joke.
  # Returns true if successful, false if any failures
  def add_missing_tags(args={})
    tag_names = args.tag_names
    tag_type = args.tag_type
    if tag_names
      tag_names.all? do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name, tag_type: tag_type)
        self.tags << tag if !self.has_tag? tag
        self.has_tag? tag
      end
    else
      true
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
    # OR query
    # tags = Tag.where(name: tag_names)
    # jokes = tags.map{|tag| tag.jokes }.flatten

    # OR query
    jokes = Joke.joins(:tags).where(tags: { name: tag_names })
  	(jokes.size > 0) ? jokes.sample : nil
  end

  def has_tag?(tag)
    self.tags.include? tag
  end


  # Queries local if this query has been run before
  # else queries API and returns a random joke.
  # Errors or indication of no joke found if joke.errors.size > 0  
  def self.search_jokes(args)
    keyword_names_dirty = args.keyword_names

    errors = []
    if keyword_names_dirty.blank?
      status 422
      errors << "A keyword must be specified"
    else
      # Data cleanse
      keywords = Tag.clean_tags_array(keyword_names_dirty)
      keyword_names = Tag.tags_list(keywords)
      categories = Tag.clean_tags_array(category_names_dirty)
      category_names = Tag.tags_list(categories)
      tag_names = keyword_names
      tag_names.concat(category_names)

      if !Tag.queried_by_past_users?(tag_names)
        response = Joke.query_api_for_jokes(keyword_names: keyword_names, category_names: category_names)
        if response.success
          joke = Joke.get_random_joke(tag_names)
        else
          joke = Joke.new
          joke.errors = response.errors
        end
      else
        joke = Joke.get_random_joke(tag_names)
      end
      joke
    end
  end

  private


  # Returns a response object.
  # response.errors is an array of errors, if any
  # response.success is true if no errors
  def self.query_api_for_jokes(args={})
    keyword_names = args.keyword_names
    category_names = args.category_names
    response = {}
    response.errors = []

    api_response = Joke.send_api_query(keyword_names: keyword_names, category_names: category_names)
    joke_collection = (api_response) ? api_response.body : nil

    if joke_collection
      response.success = joke_collection.all? do |joke_data|
        tag_names.concat(Tag.clean_tags_array(joke_data["category"])) # Add API's own categories to our database of tags
        tag_names.uniq!  # Remove duplicates introduced

        joke = Joke.add_joke(joke_data["joke"])
        if !joke.nil? && joke.add_missing_tags(tag_names: keywords_list, tag_type: 'user_queried') && joke.add_missing_tags(tag_names: categories_list, tag_type: 'api_result')
          true
        else
          status 500
          response.errors << "500:Internal Server Error"
          false
        end
      end # end joke_data
    else 
      status 503
      response.errors << "503:Service Unavailable"
      response.success = false
    end
    response
  end

  def self.send_api_query(args = {})
      keyword_names = args.keyword_names
      category_names = args.category_names

      # Joke API defined in environment.rb
      url = API_URL

      # Keywords (mandatory)
      if !keyword_names.blank?
        url += "&keywords=#{keyword_names}&numJokes=#{MAX_JOKES}&minRating=#{MIN_JOKE_RATING}"
      else
        raise "A keyword must be specified."
      end

      # Categories (optional)
      if !category_names.blank?
        url += "category=#{category_names}"
      end

      response = Unirest.get url,
        headers:{
         "X-Mashape-Key" => API_KEY,
         "Accept" => "application/json"
        }
  end

end
