class Widget::UserPanel < Qt::Widget

	def initialize user
		super()
		
		@layout = Qt::VBoxLayout.new self
		@user_panel  = Qt::Widget.new 
		add_top_menu_bar
		add_top_label
		add_user_list
		add_pagination_button_group
		add_main_button_group
		
		display_window
		add_user_panel
	end

	def add_user_panel
		@panel_width = 400
		setFixedSize @panel_width, 500
		add_panel_parts
	end

	def add_panel_parts
		@user_panel_layout = Qt::VBoxLayout.new self
		@user_panel_layout.set_contents_margins 20, 0, 0, 20
		add_portrait
		add_user_info
		add_user_button_group
	end

	def add_portrait
		@user_portrait = Qt::Label.new
		load_file
		@user_portrait.alignment =  Qt::AlignHCenter
		@user_portrait.setFixedSize 360, 60
		@user_panel_layout.addWidget @user_portrait, 1, Qt::AlignAbsolute
	end

	def load_file
		file_name = "user.jpg" #@selected_user.image ||
		image = Qt::Pixmap.new "images/avatars/#{file_name}"
		h 	  = @user_portrait.height
		w     = @user_portrait.width
		@user_portrait.pixmap = image.scaledToHeight(h, Qt::SmoothTransformation)
	end

	def add_user_info
		@user_display = Widget::UserTable.new @selected_user
		@user_panel_layout.addWidget @user_display, 1
	end

	def add_user_button_group
		user_actions = Qt::Widget.new
		user_actions.set_fixed_size 350, 50
		setStyleSheet("QGroupBox {background-color: red;}")
		@actions_layout = Qt::HBoxLayout.new user_actions
		@actions_layout.set_contents_margins 10, 0, 0, 20
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
	
end