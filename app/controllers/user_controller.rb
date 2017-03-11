require 'Qt'

class UserController < Controller

	def index 
		User::Index.new
	end
	
	def create
		user = Utilisateur.new
		User::Create.new user
	end

	def update user
		User::Update.new user
	end

	def import
		User::Import.new
	end
end