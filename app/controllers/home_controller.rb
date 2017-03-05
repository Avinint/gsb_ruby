require 'Qt'

class HomeController < Controller

	def login
		Home::Login.new
	end
	
	def welcome
		Home::Welcome.new
	end
end