require 'Qt'

class UserController < Controller

	def index 
		User::Index.new
	end
	
end