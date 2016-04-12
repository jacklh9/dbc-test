# Show system tags
get '/tags' do
	@user = nil  # Explicitly stating that system tags are indicated by user_id = nil
	@tags = Tag.where(user: nil).order(name: :ASC)
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

get '/tags/:id' do
	@user = nil  # Explicitly stating that system tags are indicated by user_id = nil
	@tag = Tag.find_by(id: params[:id])
	halt '404' if @tag.nil?
	@jokes = Joke.get_jokes(keywords: [@tag.name])
	puts "HERE: #{@jokes.count}"
	@title = @tag.name
	@max_joke_title_length = MAX_JOKE_TITLE_LEN
	erb :'/jokes/index'
end

get '/tags/:id/user' do
	if current_user
		# Find a specific user's tagged jokes
		# NOT IMPLEMENTED/TESTED YET
		@user = current_user
		@tag = Tag.find_by(id: params[:id])
		@jokes = Joke.get_jokes(keywords: [@tag])
		@MAX_JOKE_TITLE = MAX_JOKE_TITLE
		erb :'/tags/index'
	else
		# This works
		redirect "/tags/#{params[:id]}"
	end
end
