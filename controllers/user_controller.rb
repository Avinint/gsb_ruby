require 'Qt'

class UserController < Controller

	def index 
		users = Utilisateur.all
		
		User::Index.new users
	end
	
end