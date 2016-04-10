# Index
# For performance reasons, we don't 
# show the entire list of jokes. Just
# the tags list.
get '/jokes' do
  redirect to '/tags'
end

# Show
get '/jokes/:id' do
	@joke = Joke.find_by(id: params[:id])
	halt '404' if @joke.nil?
	erb :'/jokes/show'
end

# Create
post '/jokes' do
  # Keywords Required
  category_names_dirty = params[:category]
  keyword_names_dirty = params[:keywords]

  @joke = Joke.search_jokes(keyword_names: keyword_names_dirty,
    category_names: category_names_dirty
    )

  @errors = @joke.errors

  erb :'/index'
end

# New Favorite Joke
post '/favorite/:id' do
  redirect to '/register' unless current_user
  @joke = Joke.find(params[:id])
  halt '404' if @joke.nil?
  if !current_user.has_this_favorite? @joke
    begin
      current_user.favorite_jokes << @joke
    rescue
      @errors = "Something went wrong attempting to favorite this joke."
      status 500
      erb :"/jokes/#{params[:id]}"
    end
  end
  redirect to "/profile/#{current_user.id}"
end

# Delete Favorite
delete '/favorite/:id' do
  redirect to '/login' unless current_user
  @joke = Joke.find_by(id: params[:id])
  current_user.favorite_jokes.delete(@joke)
  redirect "/profile/#{current_user.id}"
end
