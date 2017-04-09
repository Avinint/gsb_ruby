class User::Profile < Window

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
		setFixedSize @panel_width, 530
		add_panel_parts
		show
	end

	def add_panel_parts
		@layout.set_contents_margins 20, 0, 20, 20
		add_portrait
		add_user_info
		add_user_button_group
		set_window_title "GSB : Profil utilisateur"
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
		add_change_password_button
	end

	def add_change_password_button
		pw_button = Qt::PushButton.new "changer mot de passe"
		pw_button.connect SIGNAL :clicked do display_change_pw_page end
		@actions_layout.addWidget pw_button
	end

	def display_change_pw_page
		User::EditPassword.new @user
	end
end