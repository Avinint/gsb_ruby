class Widget::UserForm < Window
def initialize user
		super()
		@user  = user
		@roles = Role.pluck(:libelle, :nom).to_h
		layout = Qt::VBoxLayout.new self
		@form  = Qt::FormLayout.new
		layout.addLayout @form
		
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
			else
				instance_variable_set("@form_#{property}", Qt::LineEdit.new)
				label = attr.capitalize.tr("_", " ")
				field = instance_variable_get("@form_#{property}")
				field.set_text @user.send("#{property}") unless  property == 'mdp'
			end
			@form.addRow "&#{label} :", field		
		end

		button_text = @user.id.blank? ? 'Créer' : "Modifier"
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
				value = Utilisateur.encrypt @form_mdp.text 
			else
				value = instance_variable_get("@form_#{property}").text unless property == "code_postal"
			end
			@user.send("#{property}=", value) unless property == "mdp" && @form_mdp.text.blank? || property == "code_postal"
		end
		
		@user.save
		UserController.new.index
		self.close
	end
end