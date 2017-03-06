require 'Qt'
require 'pathname'

class User::Index < Window
	attr_reader :user_panel, :user_display, :user_list, :panel_width, :list_width

	def initialize users
		super()
		@users = users
		layout = Qt::HBoxLayout.new self
		add_user_list
		add_user_panel
		display_window
	end

	def add_user_list
		@user_list = Widget::UsersTable.new @users, ["prénom", "nom", "rôle", "commune"]
		layout.addWidget @user_list, 1
		@list_width = @user_list.width
	end

	def add_user_panel
		@panel_width = 400
		@user_panel    = Qt::Widget.new 
		@user_panel.setFixedSize @panel_width, @user_panel.height
		layout.addWidget @user_panel, 1, Qt::AlignCenter
		add_panel_parts
	end

	def add_panel_parts
		@user_panel_layout = Qt::VBoxLayout.new  @user_panel
		@user_panel_layout.set_contents_margins 20, 0, 0, 20
		add_portrait
		add_user_info
		add_button_group
	end

	def add_portrait
		@user_portrait = Qt::Label.new
		load_file "user.jpg"
		@user_portrait.alignment =  Qt::AlignHCenter
		@user_portrait.setFixedSize 360, 120
		@user_panel_layout.addWidget @user_portrait, 1, Qt::AlignAbsolute
	end

	def load_file file_name
	puts file_name
		file_name ||= "user.jpg"		
		image = Qt::Pixmap.new "images/avatars/#{file_name}"
		h 	  = @user_portrait.height
		w     = @user_portrait.width
		@user_portrait.pixmap = image.scaledToHeight(h, Qt::SmoothTransformation)
	end

	def add_user_info
		@user_display = Widget::UserTable.new @users.first
		@user_panel_layout.addWidget @user_display, 1
	end

	def add_button_group
		@user_actions  = Qt::GroupBox.new
		setStyleSheet("QGroupBox: {background-color: red;}")
		@actions_layout = Qt::HBoxLayout.new @user_actions
		@actions_layout.set_contents_margins 0, 0, 0, 0
		@user_panel_layout.addWidget @user_actions, 1
		add_edit_button
		add_delete_button
	end

	def add_edit_button
		edit_button = Qt::PushButton.new "modifier"
		edit_button.resize 100, edit_button.height
		@actions_layout.addWidget edit_button
	end

	def add_delete_button
		delete_button = Qt::PushButton.new "supprimer"
		delete_button.resize 100, delete_button.height
		@actions_layout.addWidget delete_button
	end

	def display_window
		@user_panel.hide
		resize @user_list.width, @user_list.height
        setWindowTitle "GSB : Gérer utilisateurs"
        show
	end
end