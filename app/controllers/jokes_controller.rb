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
  @errors = []

  # Keywords Required
  category_names_dirty = params[:category]
  keyword_names_dirty = params[:keywords]

  Joke.search_jokes(keyword_names: keyword_names_dirty,
    category_names: category_names_dirty
    )

  # Favorites button: to display or not to display...
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
