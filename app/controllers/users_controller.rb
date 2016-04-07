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
  @user = User.find_by(email: params[:user][:email])
  if @user != nil && @user.authenticate(params[:user][:password])
      session[:id] = @user.id
      redirect to :'/'
  else
    @errors = ["Username or password invalid"]
    status 401
    @user = User.new
    erb :'/users/login'
  end
end

# Show
get '/profile/:id' do
    @items = Item.where(seller_id: params[:id])
    @seller = User.find_by(id: params[:id])
    halt :'404' if @seller.nil?

  	erb :'/users/profile'
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
