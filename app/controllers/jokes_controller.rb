
post '/jokes' do
  API_KEY = "4tlyur24RtmshjkbmQB7t5PR1OQ9p1mYyIdjsn8kgVQRQBscQX"
  API_URL = "https://webknox-jokes.p.mashape.com/jokes/search?"

  # Data cleanse
  categories = Tags.clean_tags_array(params[:categories])
  categories_list = Tags.tags_list(@categories)
  keywords = Tags.clean_tags_array(params[:keywords])
  keywords_list = Tags.tags_list(@keywords)
  tags = categories
  tags.concat(keywords)

  if Tag.site_tags_exist?(tags)
  	# Return random joke from the database
  else
  	# Add [missing] tags to database
  	if Tag.add_missing_tags(tags)
	  	# Query Joke API, create hash and add jokes, tags to database if
	  	# hashes don't exist
	  url = API_URL
	  @errors = []

	  # Optional
	  if @categories.size > 0
	    url += "category=#{@categories_list}"
	  end

	  # Required
	  if @keywords.size > 0
	    
	    url += "&keywords=#{@keywords_list}&numJokes=1"
		  # response = Unirest.get url,
		  # headers:{
		  #   "X-Mashape-Key": API_KEY,
		  #   "Accept": "application/json"
		  # }

		  # if response
		  #   data = response.body.first
		  #   @joke = (data) ? data["joke"] : "No results returned."
		  # else
		  #   # Deal with down API server
		  # end
		  # puts @joke
	  	  puts @keywords.size
		  puts url
	  else
	    @errors << "Keywords is required"
	  end
  end

  erb :'/index'
end

# get '/favorite' do
#   redirect to '/logout' unless current_user
#   @joke = Joke.find(params[:joke-id])
#   @user_joke = UserJoke.new
#   @user_joke.user = current_user
#   @user_joke.joke = @joke
#   if @user_joke.save
#     redirect to "/profile/#{current_user.id}"
#   else
#     status 422
#     @errors = "Something went wrong"
#     erb :'index'
#   end
# end