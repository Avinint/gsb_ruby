require 'Qt'

class Home::Login < Window
	def initialize
		super
		@return_key_on = true
		font = Qt::Font.new "Roboto", 11, Qt::Font::Light
		font.setLetterSpacing(Qt::Font::PercentageSpacing, 99)
		
		form_frame = Qt::Widget.new
		set_font font
		form_frame.set_object_name "form_frame"
		form_frame.raise
		set_object_name "main_window"
		#form_frame.set_style_sheet "background-color:red"
		set_style_sheet "#main_window{background-image: url(app/images/background_2.jpg); background-repeat: no-repeat;}
		QWidget#form_frame QLabel{color: white;} QWidget#submit{height: 60px; font-size: 14px} QLineEdit{height: 50}
		QPushButton#reset{height: 60px; font-size: 14px;background-color :transparent; color:red; font-weight: 700}
		"
		#set_style_sheet "QLabel {color: red;}"
		logo_image = Qt::Pixmap.new("app/images/logo_login.png")
		logo = Qt::Label.new
		w = logo.width
		h = logo.height
		logo_image = logo_image.scaled(w / 10, h / 10, Qt::KeepAspectRatioByExpanding, Qt::SmoothTransformation)
		logo.pixmap = logo_image
		logo.set_fixed_size 150, 80
		layout = Qt::HBoxLayout.new self
		layout.set_contents_margins 0, 0, 0, 0
				form = Qt::FormLayout.new form_frame
		layout.add_spacing 10
		layout.add_widget logo, 2, Qt::AlignHCenter
		layout.add_widget form_frame, 3, Qt::AlignLeft
   		@login_line_edit    = Qt::LineEdit.new
   		@password_line_edit = Qt::LineEdit.new
   		@password_line_edit.setEchoMode Qt::LineEdit::Password
   		
   		@submit = Qt::PushButton.new 'connexion'
   		@submit.set_font font
   		login_label = Qt::Label.new "identifiant :"
   		password_label = Qt::Label.new "mot de passe :"
   		
		form.addRow login_label , @login_line_edit
       	form.addRow password_label, @password_line_edit

       	reset = Qt::PushButton.new 'mdp oublié'
        reset.set_object_name "reset"
       	reset.connect SIGNAL :clicked do
    		display_reset_window
        end

    	@submit.set_object_name "submit"
    	@submit.setToolTip "Se connecter"
    	form.addRow reset, @submit
    	@submit.connect SIGNAL :clicked do
    		log_me @login_line_edit.text, @password_line_edit.text
        end
        #shortcut = Qt::Shortcut.new Qt::KeySequence.new(Qt::Key_Return), self, @submit.click
        layout.add_spacing 10
        

        form_frame.set_fixed_size 300, 120
       	setFixedSize 600, 250#250, 100
       
        setWindowTitle "GSB"
        show
	end

	def logged login, password
		@user = Utilisateur.find_by_login login
		$gsb_session[:current_user] = @user if @user
		# object password before string password
		@user.present? && Auth.login(@user, password)
	end

	def log_me login, password
		if logged login, password
			message = @user.is_admin? ? "Connecté" : "Connecté sans accès administrateur"
			@return_key_on = false
			Qt::MessageBox.new(Qt::MessageBox::Information, "gsb.fr", message).exec
			
			if @user.is_admin?
				UserController.new.index
			else
				UserController.new.profile
			end
			self.close
		else
			@return_key_on = false
			msg_box = Qt::MessageBox.new(Qt::MessageBox::Information, "gsb.fr", "identifiants invalides")
			msg_box.exec
		end
	end

	def keyReleaseEvent event
	 	if @return_key_on == true && event.key == Qt::Key_Return || event.key == Qt::Key_Enter
 			@submit.click
 		else
 			@return_key_on = true
 		end
	end

	def display_reset_window
		@popup = User::ResetPassword.new self
	end

	def closeEvent event 
		@popup.close unless @popup.nil?
	end
end