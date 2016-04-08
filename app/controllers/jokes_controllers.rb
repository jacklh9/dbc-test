post '/jokes' do
  url = "https://webknox-jokes.p.mashape.com/jokes/search?"
  @errors = []

  # Required
  if params[:keywords] != ""
    url += "keywords=#{params[:keywords]}&minRating=5&numJokes=1"
  else
    @errors << "Keywords is required"
    erb :'/index'
  end

  # Optional
  if params[:category] != ""
    url += "&category=#{params[:category]}"
  end

  puts url

  response = Unirest.get url,
  headers:{
    "X-Mashape-Key" => "4tlyur24RtmshjkbmQB7t5PR1OQ9p1mYyIdjsn8kgVQRQBscQX",
    "Accept" => "application/json"
  }
  if response
    data = response.body.first
    @joke = (data) ? data["joke"] : "No results returned."
  else
    # Deal with down API server
  end
  puts @joke
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
