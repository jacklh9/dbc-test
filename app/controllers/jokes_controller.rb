# Index
# For performance reasons, we don't 
# show the entire list of jokes. Just
# the tags list.
get '/jokes' do
  set_previous_page
  redirect to '/tags'
end

# Show
get '/jokes/:id' do
  set_previous_page
	@joke = Joke.find_by(id: params[:id])
	halt '404' if @joke.nil?
	erb :'/jokes/show'
end

# Joke Search page form results from the user.
post '/jokes' do
  set_previous_page
  # Keywords Required
  keyword_names_dirty = params[:keywords]
  category_names_dirty = params[:categories]

  # Data cleanse
  keywords = Tag.clean_tags_array(keyword_names_dirty)
  categories = Tag.clean_tags_array(category_names_dirty)

  @errors = []

  if keywords.count <= 0
    @errors << "A keyword must be specified"
  else
    @joke = Joke.get_random_joke(keywords: keywords, categories: categories)
    if !@joke
      @errors << "No matches found or service unavailable."
    end
  end
  
  @keywords = params[:keywords]
  @categories = params[:categories]
  erb :'/index'
end

# New Favorite Joke
post '/favorite/:id' do
  set_previous_page
  redirect to '/register' unless current_user
  @joke = Joke.find(params[:id])
  halt '404' if @joke.nil?
  unless current_user.has_this_favorite?(@joke) 
    begin
      current_user.favorite_jokes << @joke
    rescue
      status 500
      redirect "/jokes/#{params[:id]}"
    end
  end
  redirect to "/profile/#{current_user.id}"
end

# Delete Favorite
delete '/favorite/:id' do
  set_previous_page
  redirect to '/login' unless current_user
  @joke = Joke.find_by(id: params[:id])
  current_user.favorite_jokes.delete(@joke)
  redirect "/profile/#{current_user.id}"
end
