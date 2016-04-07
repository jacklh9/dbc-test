# Index

get '/items' do
	@items = Item.all.where('auction_start <= :now AND auction_end >= :now', now: DateTime.now)
	erb :'/items/index'
end


# New
get '/items/new' do
	@item = Item.new
	@conditions = Condition.all
	erb :'/items/new'
end

# Create
post '/items' do
	@item = Item.new(params[:item])
	@conditions = Condition.all
	if @item.save
		redirect "/profile/#{current_user.id}"
	else
		@errors = @item.errors.full_messages
		erb :'/items/new'
	end
end

# Show
get '/items/:id' do
	@item = Item.find_by(id: params[:id])
	@bid = Bid.new

	  if @item
	    erb :'/items/show'
	  else
	    status 404
	    erb :'404'
	  end
end

# Edit
get '/items/:id/edit' do
  if current_user
	  @item = Item.find_by(id: params[:id])
	  @conditions = Condition.all

	  if @item && @conditions
	    erb :'/items/edit'
	  else
	    status 404
	    erb :'404'
	  end
  else
  	redirect '/login'
  end
end

# Update
patch '/items/:id' do
	if current_user 
		@item = Item.find_by(id: params[:id])
		halt :'404' if @item.nil?
		@item.assign_attributes(params[:item])

		if @item.save
			redirect "/items/#{@item.id}"
		else
			status 422
			@conditions = Condition.all
			@errors = @item.errors.full_messages
			erb :'/items/new'
		end
	else
		redirect '/login'
	end
end

# Delete
delete '/items/:id' do
	if current_user
		@item = Item.find_by(id: params[:id])
		halt :'404' if @item.nil?

		if @item.delete
			redirect "/profile/#{current_user.id}"
		else
			status 404
			erb :'404'
		end

	else
		redirect '/login'
	end
end
