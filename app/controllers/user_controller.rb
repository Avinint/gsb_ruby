require 'Qt'

class UserController < Controller

	def index
		User::Index.new
	end
	
	def paginate(start = 1)
		{ list: Utilisateur.offset(start).limit(20),  count: Utilisateur.count }
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