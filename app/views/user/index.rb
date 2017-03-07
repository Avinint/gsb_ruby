require 'Qt'
require 'pathname'

class User::Index < Window

	attr_reader :user_panel, :user_display, :user_list, :panel_width, :list_width
	attr_accessor :selected_user

	def initialize
		super()
		@selected_user = Utilisateur.first 
		layout = Qt::HBoxLayout.new self
		add_user_list
		add_user_panel
		display_window
	end

	def add_user_list
		@user_list = Widget::UsersTable.new ["prénom", "nom", "rôle", "commune"]
		layout.addWidget @user_list, 1, Qt::AlignTop
		@list_width = @user_list.width
	end

	def add_user_panel
		@panel_width = 400
		@user_panel  = Qt::Widget.new 
		@user_panel.setFixedSize @panel_width, @user_panel.height
		layout.addWidget @user_panel, 1, Qt::AlignTop
		add_panel_parts unless @selected_user.blank?
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
		load_file
		@user_portrait.alignment =  Qt::AlignHCenter
		@user_portrait.setFixedSize 360, 120
		@user_panel_layout.addWidget @user_portrait, 1, Qt::AlignAbsolute
	end

	def load_file
		file_name = @selected_user.image || "user.jpg"
		image = Qt::Pixmap.new "images/avatars/#{file_name}"
		h 	  = @user_portrait.height
		w     = @user_portrait.width
		@user_portrait.pixmap = image.scaledToHeight(h, Qt::SmoothTransformation)
	end

	def add_user_info
		@user_display = Widget::UserTable.new @selected_user
		@user_panel_layout.addWidget @user_display, 1
	end

	def add_button_group
		user_actions = Qt::Widget.new
		user_actions.set_fixed_size 350, 50
		setStyleSheet("QGroupBox {background-color: red;}")
		@actions_layout = Qt::HBoxLayout.new user_actions
		@actions_layout.set_contents_margins 10, 0, 0, 20
		@user_panel_layout.addWidget user_actions, 1
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

	def display_window
		@user_panel.hide
		resize @user_list.width, [@user_list.height, 500].max
        setWindowTitle "GSB : Gérer utilisateurs"
        show
	end

	def display_edit_page
		puts "edit display"
	end

	def confirm_delete
		popup = Qt::MessageBox.new self
		popup.window_title = 'GSB'; popup.icon = Qt::MessageBox::Critical
		popup.text = "Voulez-vous vraiment supprimer cet utilisateur?"
		popup.standardButtons  = Qt::MessageBox::Ok | Qt::MessageBox::Cancel
		delete_user if popup.exec == Qt::MessageBox::Ok
	end

	def delete_user
		previous_user = Utilisateur.where("id < ?", @selected_user.id).last
		ActiveRecord::Base.connection.update "SET FOREIGN_KEY_CHECKS = 0"
		@selected_user.destroy
		if @selected_user.destroyed?
			refresh_ui
		end
		ActiveRecord::Base.connection.update "SET FOREIGN_KEY_CHECKS = 1"
	end
	
	def refresh_ui
		@user_list.remove_row @user_list.current_row
		if @user_list.row_count > 0
			@user_list.select_user(@user_list.current_row)
		else
			@user_panel.hide
			setFixedSize @user_list.width + 20, @user_list.height + 20
		end
	end
end