get '/' do
  erb :'/index'
end

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

  puts response.body
  redirect :'/'
end
