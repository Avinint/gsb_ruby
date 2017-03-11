require 'Qt'

class Home::Login < Window
	def initialize
		super

		form = Qt::FormLayout.new self
   		login_line_edit    = Qt::LineEdit.new
   		password_line_edit = Qt::LineEdit.new
   		password_line_edit.setEchoMode Qt::LineEdit::Password
   		
   		submit = Qt::PushButton.new 'login'
		form.addRow tr("&Login:"), login_line_edit
       	form.addRow tr("&Mot de passe:"), password_line_edit
        form.addRow submit
    	
    	submit.resize 100, 30
    	
    	submit.setToolTip "Se connecter"
    	submit.connect SIGNAL :clicked do
    		log_me login_line_edit.text, password_line_edit.text
        end
       	setFixedSize 250, 100
       	
        setWindowTitle "GSB"
        show
	end

	def logged login, password
		@user = Utilisateur.find_by_login login
		$gsb_session[:current_user] = @user
		# object password before string password
		@user.present? && Auth.login(@user, password)
	end

	def log_me login, password
		if logged login, password
			message = @user.is_admin? ? "Connecté" : "Connexion non autorisé"
			Qt::MessageBox.new(Qt::MessageBox::Information, "gsb.fr", message).exec
			HomeController.new.welcome if @user.is_admin?
			self.close if @user.is_admin? && logged(login, password)
		else
			Qt::MessageBox.new(Qt::MessageBox::Information, "gsb.fr", "identifiants invalides").exec
		end
	end
end