require 'Qt'
require 'pathname'

class User::Index < Window
	attr_reader :user_panel, :user_display, :user_list, :panel_width, :list_width

	def initialize users
		super()
		setStyleSheet("QLabel {font-size: 11pt}")
		
		@panel_width = 400
		layout = Qt::HBoxLayout.new self
		@user_list = Widget::UsersTable.new users, ["prénom", "nom", "rôle", "commune"]
		@user_panel = Qt::Widget.new 
		@user_portrait = Qt::Label.new
		
		@user_panel.setFixedSize @panel_width, @user_panel.height
		user_view_layout = Qt::VBoxLayout.new  @user_panel
		add_portrait users.first.image
		@user_portrait.alignment =  Qt::AlignHCenter
		@user_portrait.setFixedSize 360, 120
		@user_display = Widget::UserTable.new users.first
		
		layout.addWidget @user_list, 1
		layout.addWidget @user_panel, 1, Qt::AlignCenter

		@user_panel.hide
		user_view_layout.addWidget @user_portrait, 1, Qt::AlignAbsolute
		user_view_layout.addWidget @user_display, 1
		user_view_layout.set_contents_margins 20, 0, 0, 0

		@list_width = @user_list.width
		resize @user_list.width, @user_list.height
        setWindowTitle "GSB : Gérer utilisateurs"
        show
	end

	def add_portrait file_name
		file_name ||= "user.jpg"		
		image = Qt::Pixmap.new "images/avatars/#{file_name}"
		h 	  = @user_portrait.height
		w     = @user_portrait.width
		image = image.scaledToHeight(h, Qt::SmoothTransformation)
		@user_portrait.pixmap = image
	end
end