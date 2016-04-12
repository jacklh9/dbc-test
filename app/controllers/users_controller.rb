# New
get '/register' do
  @user = User.new();
  erb :'/users/register'
end

# Create
post '/register' do
  @user = User.new(params[:user])

  if User.min_passwd_length?(params[:user][:password]) && @user.save
    session[:id] = @user.id
    redirect to '/'
  else
    status 404
    @errors = @user.errors.full_messages
    @errors << "Password must be minimum length of 8 characters" if !User.min_passwd_length?(params[:user][:password])
    erb :'/users/register'
  end
end

# Login
get '/login' do
  @user = User.new
  erb :'/users/login'
end

post '/login' do
  user = User.find_by(email: params[:user][:email])
  if user != nil && user.authenticate(params[:user][:password])
      session[:id] = user.id
      redirect to :"/profile/#{user.id}"
  else
    @errors = ["Username or password invalid"]
    status 401
    @user = User.new
    erb :'/users/login'
  end
end

# Show
get '/profile/:id' do
  @profile_user = User.find_by(id: params[:id])
  halt '404' if @profile_user.nil?
  if current_user
    @jokes = current_user.favorite_jokes.order(content: :ASC)
    @max_joke_title_length = MAX_JOKE_TITLE_LEN
  	erb :'/users/profile'
  else
    redirect '/login'
  end
end

# Logout
get '/logout' do
	if current_user
		erb :'/users/logout'
	else
		redirect '/login'
	end
end

delete '/logout' do
	if current_user
	  session[:id] = nil
	  redirect '/'
	else
		redirect '/login'
	end
end
