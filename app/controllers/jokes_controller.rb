get '/jokes/:id' do
	@joke = Joke.find_by(id: params[:id])
  if current_user && (!current_user.favorite_jokes.include? @joke)
    @display_button = true
  else
    @display_button = false
  end
	halt '404' if @joke.nil?
	erb :'/jokes/show'
end


post '/jokes' do
  API_KEY = ENV['JOKE_API_KEY']
  API_URL = "https://webknox-jokes.p.mashape.com/jokes/search?"
  MAX_JOKES = 10
  MIN_JOKE_RATING = 0
  @errors = []

  	puts params[:keywords]
  @keywords = params[:keywords]
  @category = params[:category]
	# Data cleanse
	keywords = Tag.clean_tags_array(params[:keywords])
	keywords_list = Tag.tags_list(keywords)
	categories = Tag.clean_tags_array(params[:categories])
	categories_list = Tag.tags_list(categories)
	tag_names = keywords
	tag_names.concat(categories)

  # Keywords Required
  if keywords.size > 0

  	if Tag.site_tags_exist?(tag_names)
		@joke = Joke.get_random_joke(tag_names)
 	else
	  	# Joke API
	    url = API_URL
		url += "&keywords=#{keywords_list}&numJokes=#{MAX_JOKES}&minRating=#{MIN_JOKE_RATING}"
		# Optional
		if categories.size > 0
		  url += "category=#{categories_list}"
		end

		# Query Joke API, create hash and add jokes
		puts "CONTACTING URL: #{url}"
		puts "USING KEY: #{API_KEY}"

		response = Unirest.get url,
		  headers:{
		   "X-Mashape-Key" => API_KEY,
		   "Accept" => "application/json"
		  }

		if response
		  joke_collection = response.body
		  puts "JOKE_COLLECTION: #{joke_collection}"
		  joke_collection.each do |joke_data|
		  	puts "JOKE DATA: #{joke_data}"
		  	tag_names.concat(Tag.clean_tags_array(joke_data["category"]))	# Add API's own category to our database of tags
		  	tag_names.uniq!
		  	puts "TAGS: #{tag_names}"
		  	joke_object = Joke.add_joke(joke_data["joke"])
		  	if joke_object.valid? && joke_object.add_missing_tags(tag_names)
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
  else
  	status 422
	@errors << "Keywords is required"
  end
  if current_user && (!current_user.favorite_jokes.include? @joke)
    @display_button = true
  else
    @display_button = false
  end
  if !@joke
  	@errors << "No results found."
  end
  erb :'/index'
end

post '/favorite/:id' do
  redirect to '/login' unless current_user
  @joke = Joke.find(params[:id])
  if current_user && (!current_user.favorite_jokes.include? @joke)
    @user_joke = UserJoke.new
    @user_joke.user = current_user
    @user_joke.joke = @joke
    puts @user_joke
    if @user_joke.save
      redirect to "/profile/#{current_user.id}"
    else
      status 500
      @errors = "Something went wrong"
      erb :'index'
    end
  else
    redirect to "/profile/#{current_user.id}"
  end
end

delete '/favorite/:id' do
  redirect to '/login' unless current_user
  @joke = Joke.find_by(id: params[:id])
  current_user.favorite_jokes.delete(@joke)
  redirect "/profile/#{current_user.id}"

end
