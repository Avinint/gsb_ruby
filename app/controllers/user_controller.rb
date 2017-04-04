require 'Qt'

class UserController < Controller

	def index
		User::Index.new
	end
	
	def show user
		User::Show.new user
	end

	def paginate page = 1, per_page = 20
		nbr_page = (Utilisateur.count.to_f / per_page.to_f).ceil
		{ list: Utilisateur.offset((page - 1) * per_page).limit(per_page), count: Utilisateur.count, nbr_page: nbr_page }
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