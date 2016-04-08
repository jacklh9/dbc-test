API_KEY = "4tlyur24RtmshjkbmQB7t5PR1OQ9p1mYyIdjsn8kgVQRQBscQX"
API_URL = "https://webknox-jokes.p.mashape.com/jokes/search?"

post '/jokes' do
  @categories = params[:categories].downcase.split(',').map(&:strip)
  @keywords = params[:keywords].downcase.split(',').map(&:strip)

  puts @categories
  puts @keywords

  redirect '/'

  # url = API_URL
  # @errors = []

  # # Required
  # if params[:keywords] != ""
  #   url += "keywords=#{params[:keywords]}&minRating=5&numJokes=1"
  # else
  #   @errors << "Keywords is required"
  #   erb :'/index'
  # end

  # # Optional
  # if params[:category] != ""
  #   url += "&category=#{params[:category]}"
  # end

  # puts url

  # response = Unirest.get url,
  # headers:{
  #   "X-Mashape-Key": API_KEY,
  #   "Accept": "application/json"
  # }

  # puts response.body
  # erb :'/index'
end


