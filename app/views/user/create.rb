require 'Qt'

class User::Create < Widget::UserForm
	def initialize user
		super
		setWindowTitle "GSB : Créer utilisateur"
    	show
	end
end