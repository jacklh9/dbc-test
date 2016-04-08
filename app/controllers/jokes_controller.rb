API_KEY = "4tlyur24RtmshjkbmQB7t5PR1OQ9p1mYyIdjsn8kgVQRQBscQX"
API_URL = "https://webknox-jokes.p.mashape.com/jokes/search?"

post '/jokes' do
  @categories = params[:categories].downcase.split(',').map(&:strip).map{ |c| c.gsub(/\s{2,}/, ' ')}
  @keywords = params[:keywords].downcase.split(',').map(&:strip).map{ |k| k.gsub(/\s{2,}/, ' ')}

  url = API_URL
  @errors = []

  # Optional
  if @categories.size > 0
    url += "category=#{@categories.join(',')}"
  end

  # Required
  if @keywords.size > 0
    url += "&keywords=#{@keywords.join(',')}&numJokes=1"
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