require 'Qt'

class User::EditPassword < Qt::Dialog
	def initialize user
		super()
		@user = user
		setWindowTitle "GSB : Changer mot de passe"
		form = Qt::FormLayout.new self
		@password_line_edit = Qt::LineEdit.new
		@password_confirm_edit = Qt::LineEdit.new
   		@password_line_edit.setEchoMode Qt::LineEdit::Password
   		@password_confirm_edit.setEchoMode Qt::LineEdit::Password
		form.addRow "&Mot de passe", @password_line_edit
       	form.addRow "&Confirmer", @password_confirm_edit
       	submit = Qt::PushButton.new "Changer"
       	form.addRow submit
       	set_fixed_size 300, 100
       	show
       	submit.connect SIGNAL :clicked do
       		change_password
       	end

		self.exec
   #  	
    	self.close
	end

	def change_password
		confirmed = @password_line_edit.text == @password_confirm_edit.text
		if confirmed
			message = "mot de passe mis à jour" 
			@user.mdp = Utilisateur.encrypt @password_line_edit.text
			@user.save
		else
			message = "Echec confirmation de mot de passe"
		end
		popup = Qt::MessageBox.new self
		popup.window_title = 'GSB'
		popup.text = message
		popup.exec
		self.close
	end

end