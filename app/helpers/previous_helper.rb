helpers do
  
	def set_previous_page 
		session[:return_to] ||= request.referer
	end
end