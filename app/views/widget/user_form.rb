require 'mail'

class Widget::UserForm < Window
def initialize user
		super()
		@user  = user
		@create_mode = user.id.blank?
		@roles = Role.pluck(:libelle, :nom).to_h
		@layout = Qt::VBoxLayout.new self
		@form  = Qt::FormLayout.new
		@layout.addLayout @form
		
		@attributes = %w(login mdp email nom prénom telephone adresse code_postal commune rôle date_embauche)
		@attributes.each do |attr|
			property = attr.parameterize
			if property == "role"
				field = @form_role = Qt::ComboBox.new
				label = attr.capitalize.tr("_", " ")
				@roles.map {|libelle, nom| @form_role.addItem libelle, Qt::Variant.new(nom) }
				if @user.role.present?
					field.set_current_index @roles.keys.find_index @user.role.to_s
				else
					field.set_current_index 1
				end
			elsif property == "date_embauche"
				field = @form_date_embauche = Qt::CalendarWidget.new
				field.resize 250, 250
				label = "Date d'embauche"
				date = @user.date_embauche.present? ? Qt::Date.new(@user[:date_embauche].year, @user[:date_embauche].month, @user[:date_embauche].day) : Qt::Date.new
				@form_date_embauche.setSelectedDate date 
			elsif attr == "code_postal"
			 	field = @form_code_postal = Qt::LineEdit.new
			 	label = attr.capitalize.tr("_", " ")
			 	if @user.commune.present?
			 		field.set_text @user.commune.code_postal
				end
			 	field.connect SIGNAL "textChanged(QString)" do |string|
			 		@form_commune.clear
		 			if @form_commune.children.count
				 		@communes = Commune.where(code_postal: string).pluck(:nom, :id).to_h 
				 		@communes.map {|nom, id| @form_commune.addItem nom, Qt::Variant.new(id) }
				 		@form_commune.set_current_index 0
				 	end
			 	end
			elsif attr == "commune"
				@form_commune = Qt::ComboBox.new
				label = attr.capitalize
				if @user.commune.present?
					@communes = Commune.where(code_postal: @form_code_postal.text).pluck(:nom, :id).to_h
					@communes.map {|nom, id| @form_commune.addItem nom, Qt::Variant.new(id) }
				end
				field = @form_commune
				if @user.commune.present?
					field.set_current_index @communes.keys.find_index @user.commune.to_s
				end
			elsif attr == "mdp"
				label = "Mot de passe"
				field = @form_mdp = Qt::LineEdit.new
				@form_mdp.setEchoMode Qt::LineEdit::Password
			else
				instance_variable_set("@form_#{property}", Qt::LineEdit.new)
				label = attr.capitalize.tr("_", " ")
				field = instance_variable_get("@form_#{property}")
				field.set_text @user.send("#{property}") unless property == 'mdp'
			end
			@form.addRow "&#{label} :", field		
		end

		button_text = @create_mode ? 'Créer' : "Modifier"
		submit = Qt::PushButton.new button_text
		submit.connect SIGNAL :clicked do
    		save_user
        end
		layout.add_widget submit
	end

	def save_user
		@user.role_id = 1 if @user.role_id.blank?
		@attributes.each do |attr|
			property = attr.parameterize.to_s
			if property == "date_embauche"
				value = instance_variable_get("@form_#{property}").selectedDate.to_string Qt::ISODate
			elsif property == "role"
				value = Role.find_by_nom @form_role.item_data(@form_role.current_index).to_string
			elsif property == "commune"
				property = "commune_id"
				value = @form_commune.item_data(@form_commune.current_index).to_i
			elsif property == "mdp"
				@mdp = @form_mdp.text 
				value = Utilisateur.encrypt @form_mdp.text 
				
			else
				value = instance_variable_get("@form_#{property}").text unless property == "code_postal"
			end
			@user.send("#{property}=", value) unless property == "mdp" && @form_mdp.text.blank? || property == "code_postal"
		end
		
		missing_field = nil
		
		if @user.mdp.blank? && @create_mode
			missing_field = "mot de passe"
		end
		%w(login email nom prenom commune).each do |property|
			if @user.send("#{property}").blank?
				missing_field = property
				break
			end
		end
		puts @user.login
		if missing_field.blank? && test_uniques(@user.login, @user.email)
			@user.save
			call_message_box "Utilisateur créé : #{@user.nom_complet}"
			send_mail @mdp if @create_mode && @mdp.present?
			UserController.new.index
			self.close
		else
			call_message_box "propriété requise : \"#{missing_field}\"" if missing_field.present?
		end
	end
	
	def test_uniques login, email
	
		result = Utilisateur.find_by_login login
		result = Utilisateur.find_by_email email if result.blank?
		puts "#{result.email} #{result.login}" if result.present?
		call_message_box "Login et email doivent être uniques" if result.present?
		result.blank? 
	end

	def call_message_box text
		message = Qt::MessageBox.new self
		message.text =  text
		message.set_style_sheet "QPushButton {background-color: white; color: black; 
		height: 10px; min-width: 100px;padding: 6px 3px 6px 3px; border: 1px solid black;
		border-radius: 0; 
		}"
		set_popup_font message
		message.exec
	end
	
	
	def send_mail mdp
		user = @user
		body_text = msg_body_text user, mdp
		Mail.deliver do
			charset = "UTF-8"
		    to user.email
		    from "team.gsble@gmail.com"
		  	subject "Nouveau compte créé : #{user.nom_complet}"
		    body body_text
		end
	end

	def msg_body_text user, mdp
		"Cher #{user.nom_complet}
	    	Votre  super compte GSB a été créé.
	    	Vos identifiants :
		        Login : #{user.login}
		        mot de passe : #{mdp}"
	end
end