class User::Show < Qt::Widget

	def initialize user
		super()
		@user = user
		@layout = Qt::VBoxLayout.new self
		 
		add_top_menu_bar
		add_user_panel
	end

	def add_top_menu_bar
		@menu_bar = GSBMenuBar.new self
		@layout.add_widget @menu_bar
	end

	def add_user_panel
		@panel_width = 400
		setFixedSize @panel_width, 500
		add_panel_parts
		show
	end

	def add_panel_parts
		@layout.set_contents_margins 20, 0, 20, 20
		add_portrait
		add_user_info
		add_user_button_group
	end

	def add_portrait
		@user_portrait = Qt::Label.new
		load_file
		@user_portrait.alignment =  Qt::AlignHCenter
		@user_portrait.setFixedSize 360, 120
		@layout.addWidget @user_portrait, 1, Qt::AlignAbsolute
	end

	def load_file
		file_name = "user.jpg" #@user.image ||
		image = Qt::Pixmap.new "images/avatars/#{file_name}"
		h 	  = @user_portrait.height / 4
		w     = @user_portrait.width / 4
		@user_portrait.pixmap = image.scaledToHeight(h, Qt::SmoothTransformation)
	end

	def add_user_info
		@user_display = Widget::UserTable.new @user
		@layout.addWidget @user_display, 1
	end

	def add_user_button_group
		user_actions = Qt::Widget.new
		user_actions.set_fixed_size 350, 40
		setStyleSheet("QGroupBox {background-color: red;}")
		@actions_layout = Qt::HBoxLayout.new user_actions
		@actions_layout.set_contents_margins 10, 0, 0, 10
		@layout.addWidget user_actions, 1
		add_edit_button
		add_delete_button
	end

	def add_edit_button
		edit_button = Qt::PushButton.new "modifier"
		edit_button.connect SIGNAL :clicked do display_edit_page end
		@actions_layout.addWidget edit_button
	end

	def add_delete_button
		delete_button = Qt::PushButton.new "supprimer"
		delete_button.connect SIGNAL :clicked do confirm_delete end
		@actions_layout.addWidget delete_button
	end
	
	def display_edit_page
		UserController.new.update @user
		self.close
	end

	def confirm_delete
		popup = Qt::MessageBox.new self
		popup.window_title = 'GSB'; popup.icon = Qt::MessageBox::Critical
		popup.text = "Voulez-vous vraiment supprimer cet utilisateur?"
		popup.standardButtons  = Qt::MessageBox::Ok | Qt::MessageBox::Cancel
		delete_user if popup.exec == Qt::MessageBox::Ok
	end

	def delete_user
		
		ActiveRecord::Base.connection.update "SET FOREIGN_KEY_CHECKS = 0"
		@user.destroy
		if @user.destroyed?
			message_text = "Utilisateur supprimé"
			 
		else
			message_text = "Il y a eu un erreur lors de la suppression"
		end
		result_popup = Qt::MessageBox.new self
		result_popup.window_title = 'GSB'
		result_popup.text = message_text
		result_popup.exec
		ActiveRecord::Base.connection.update "SET FOREIGN_KEY_CHECKS = 1"
		UserController.new.index
		self.close
	end
end