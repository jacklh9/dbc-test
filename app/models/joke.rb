class Joke < ActiveRecord::Base
  validates :content, :joke_hash, {presence: true, uniqueness: true}

  has_many :joke_tags
  has_many :tags, through: :joke_tags
  has_many :user_jokes
  has_many :users, through: :user_jokes

  MAX_HASH_LENGTH = 20

  # Given a collection of tag names, associates
  # those in the database with the joke.
  # If user explictly passed in a tag_type desired,
  # confirms tag is set to tag_type else sets to tag_type.
  # Returns true if successful, false if any failures.
  def add_missing_tags(args={})
    tag_names_collection = args[:tag_names_collection]
    tag_type_name = args[:tag_type_name]
    if tag_names_collection
      tag_names_collection.all? do |tag_name|
        tag_type = TagType.find_by(name: tag_type_name)
        tag = Tag.find_or_create_by(name: tag_name)

        # Set if user explicitly wants a tag_type set
        if tag_type && (tag.tag_type != tag_type)
          tag.tag_type = tag_type
        end

        # Associate joke to tag
        self.tags << tag unless self.has_tag?(tag)

        # Confirm all's as expected
        tag.save && self.has_tag?(tag)
      end
    end
  end

  def self.get_jokes(args={})
    keywords = args[:keywords]
    categories = (args[:categories]) ? args[:categories] : []
    tag_names_collection = Tag.merge(keywords,categories)
    Joke.populate_database_if_not_exist(keywords: keywords, categories: categories)
    jokes = Joke.joins(:tags).where(tags: { name: tag_names_collection })
    (jokes.size > 0) ? jokes.order(content: :ASC) : nil
  end

  def self.get_random_joke(args={})
    keywords = args[:keywords]
    categories = args[:categories]
    tag_names_collection = Tag.merge(keywords,categories)
    Joke.populate_database_if_not_exist(keywords: keywords, categories: categories)
    # OR query
    jokes = Joke.joins(:tags).where(tags: { name: tag_names_collection })
  	(jokes.size > 0) ? jokes.sample : nil
  end

  def has_tag?(tag)
    self.tags.include? tag
  end

  private

  # Returns joke object if joke already exists or
  # add was successful.
  def self.add_joke(content)
    joke_hash = Joke.generate_hash(content)
    existing_joke = Joke.find_by(joke_hash: joke_hash)
    (existing_joke) ? existing_joke : Joke.create(content: content, joke_hash: joke_hash)
  end

  def self.generate_hash(content)
    md5 = Digest::MD5.new
    md5 << "#{content}"
    joke_hash = md5.hexdigest 
    joke_hash[0..MAX_HASH_LENGTH]
  end

  # Queries local if this query has been run before
  # else queries remote API. 
  # Returns success if db has the jokes.
  def self.populate_database_if_not_exist(args={})
    keywords = args[:keywords]
    categories = args[:categories]

    unless (Tag.queried_by_past_users?(keywords) && Tag.is_cached?(categories))
      # Populate database with several jokes of these keywords/categories.
      Joke.query_api_for_jokes(keywords: keywords, categories: categories)
    else
      true
    end
  end

  # Returns true if no errors, else false
  def self.query_api_for_jokes(args={})
    keywords = args[:keywords]
    categories = (args[:categories]) ? args[:categories] : []

    api_response = Joke.send_api_query(keywords: keywords, categories: categories)
    joke_collection = (api_response) ? api_response.body : nil

    if joke_collection
      status = joke_collection.all? do |joke_data|
        joke = Joke.add_joke(joke_data["joke"])
        categories.concat(Tag.clean_tags_array(joke_data["category"])) if joke_data["category"] # Add API's own categories to our database of tags
        categories.uniq!  # Remove duplicates introduced

        if joke && joke.add_missing_tags(tag_names_collection: keywords, tag_type_name: USER_QUERY) && joke.add_missing_tags(tag_names_collection: categories)
          status = true
        else
          puts "500:Internal Server Error"
          status = false
        end
      end # end joke_data
    else 
      status = false
    end
    status
  end

  # Returns API response object
  def self.send_api_query(args = {})
      keyword_names = Tag.tags_list(args[:keywords])
      category_names = Tag.tags_list(args[:categories])

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

      puts "*" * 50
      puts "DATETIME: #{DateTime.now}"
      puts "QUERY: #{url}"
      response = Unirest.get url,
        headers:{
         "X-Mashape-Key" => API_KEY,
         "Accept" => "application/json"
        }
      response
  end

end
