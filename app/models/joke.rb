class Joke < ActiveRecord::Base
  validates :content, :joke_hash, {presence: true, uniqueness: true}

  has_many :tags, through: :joke_tags
  has_many :users, through: :user_jokes

  MAX_HASH_LENGTH = 20

  def hash
  	joke_hash
  end

  def hash=(joke)
    self.joke_hash = Joke.generate_hash(joke)
  end

  def self.generate_hash(joke)
  	Digest::MD5.hexdigest(joke)[0..MAX_HASH_LENGTH]
  end

  def self.get_random_joke(tags)
  	jokes = Joke.where(tags: tags)
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
  		Joke.create(content: content, hash: content)
  	end
  end

end
