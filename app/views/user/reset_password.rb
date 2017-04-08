require 'Qt'
require 'securerandom'

class User::ResetPassword < Qt::Dialog
	def initialize parent
		super
		setWindowTitle "GSB : Récupération de mot de passe"
		layout = Qt::VBoxLayout.new self

		header_request = Qt::Label.new "Demander code de récupération de compte"
		layout.add_widget header_request

		form_box = Qt::Widget.new
		form     = Qt::FormLayout.new form_box

		layout.add_widget form_box
		@email_line_edit = Qt::LineEdit.new	
		form.addRow "&Email", @email_line_edit
       	submit = Qt::PushButton.new "Envoyer"
       	form.addRow submit

		header_give_code = Qt::Label.new "Entrer le code de récupération envoyé par email"
		layout.add_widget header_give_code
		
		recovery_form_box = Qt::Widget.new
		recovery_form 	  = Qt::FormLayout.new recovery_form_box
		layout.add_widget recovery_form_box

		@code_line_edit = Qt::LineEdit.new	
		recovery_form.add_row Qt::Label.new "Code récupération"
		recovery_form.add_row  @code_line_edit
		submit_code = Qt::PushButton.new "Envoyer"
       	recovery_form.add_row submit_code


       	set_fixed_size 300, 250
       	show
       	submit.connect SIGNAL :clicked do
       		request_reset_password @email_line_edit.text
       	end

       	submit_code.connect SIGNAL :clicked do
       		connect_via_code
       	end

		self.exec 
    	self.close
	end

	def request_reset_password email
		user = Utilisateur.find_by_email email
		if user.present?
			message = "email envoyé" 
			user.token = SecureRandom.uuid.gsub("-", "").hex
			user.save
			send_mail user
		else
			message = "Utilisateur non reconnu"
		end
		call_popup message
		
		self.close if user.present?
	end

	def send_mail user
		body_text = msg_body_text user
		Mail.deliver do
			charset = "UTF-8"
		    to user.email
		    from "team.gsble@gmail.com"
		  	subject "GSB : Récupération de mot de passe oublié"
		    body body_text
		end
	end

	def msg_body_text user
		"Cher #{user.nom_complet}
	    	Voici votre cotre code unique pour vous connecter :
	    	
		        Code : #{user.token}
		        
		    Veuillez remplir le  formulaire \"code unique\" de la fenêtre \"récupération de mot de passe\""
	end

	def connect_via_code
		user = Utilisateur.find_by_token @code_line_edit.text
		if user.present?
			$gsb_session[:current_user] = user
			UserController.new.profile
			
			parent.close
			self.close
		else
			call_popup "Code non reconnu"
		end
	end

	def call_popup message
		@popup = Qt::MessageBox.new self
		@popup.window_title = 'GSB'
		@popup.text = message
		@popup.exec
	end
end