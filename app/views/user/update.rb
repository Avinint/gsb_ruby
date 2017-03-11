require 'Qt'

class User::Update < Widget::UserForm
	def initialize user
		super
		setWindowTitle "GSB : Modifier utilisateur"
    	show
	end
end