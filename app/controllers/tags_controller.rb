

# Show system tags
get '/tags' do
	@user = nil  # Explicitly stating that system tags are indicated by user_id = nil
	@tags = Tag.where(user: nil)
	erb :'/tags/index'	
end

# Show user tags
get '/tags/user' do
	if current_user
		@user = current_user
		@tags = Tag.where(user: current_user)
		erb :'/tags/index'
	else
		redirect '/tags'
	end
end

MAX_JOKE_TITLE_LEN = 50

get '/tags/:id' do
	@user = nil  # Explicitly stating that system tags are indicated by user_id = nil
	@tag = Tag.find_by(id: params[:id])
	@jokes = @tag.jokes
	@max_joke_title_length = MAX_JOKE_TITLE_LEN
	erb :'/jokes/index'	
end

get '/tags/:id/user' do
	if current_user
		@user = current_user
		@tag = Tag.find_by(id: params[:id])
		@jokes = Joke.get_joke([@tag])
		@MAX_JOKE_TITLE = MAX_JOKE_TITLE
		erb :'/tags/index'	
	else 
		redirect "/tags/#{params[:id]}"
	end
end