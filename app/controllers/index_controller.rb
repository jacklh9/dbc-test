get '/' do
  erb :'/index'
end

get '/previous' do
  redirect to session.delete(:return_to)
end

get '/search' do
  redirect to '/'
end

