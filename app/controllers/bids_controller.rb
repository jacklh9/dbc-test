# New
post '/bids/new' do
	bid = Bid.new(params[:bid])
	if bid.save
		redirect "/items/#{bid.item.id}"
	else
		status 500
		erb :'500'
	end
end




