get '/' do
  erb :'/index'
end

get '/search' do
  redirect to '/'
end
