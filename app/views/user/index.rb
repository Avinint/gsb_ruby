require 'Qt'
require 'pathname'

class User::Index < Window

	attr_reader :user_panel, :user_display, :user_list, :panel_width, :list_width
	attr_accessor :selected_user

	def initialize
		super()
		setStyleSheet "QPushButton {background-color: yellow;}"
		@selected_user = Utilisateur.offset(1).first 
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
	
	def add_top_menu_bar
		@menu_bar = GSBMenuBar.new self
		@layout.add_widget @menu_bar
	end

	def add_top_label
		label = Qt::Label.new
		image = Qt::Pixmap.new("app/images/background.jpg")
		image = image.scaled(420, 50, Qt::KeepAspectRatioByExpanding, Qt::SmoothTransformation)
		
		#set_style_sheet "QLabel {background-color: green; color: white}"
		label.pixmap = image
		label.setAlignment Qt::AlignCenter
		@layout.insert_widget 1, label
	end

	def add_user_list
		@user_list = Widget::UsersTable.new ["prénom", "nom", "rôle", "commune"]
		layout.addWidget @user_list, 1, Qt::AlignTop
		@list_width = @user_list.width
	end

	def add_pagination_button_group
		@pagination_actions = Qt::Widget.new
		@pagination_actions.set_fixed_size @list_width, 50
		
		@pagination_buttons_layout = Qt::HBoxLayout.new @pagination_actions
		@pagination_buttons_layout.set_contents_margins 10, 0, 0, 20
		@layout.addWidget @pagination_actions, 1, Qt::AlignTop
		
		@first_button = Qt::PushButton.new "<<"
		@pagination_buttons_layout.addWidget @first_button 
		@first_button.connect SIGNAL :clicked do display_create_page end
		@prev_button = Qt::PushButton.new "<"
		@pagination_buttons_layout.addWidget @prev_button
		@prev_button.connect SIGNAL :clicked do display_create_page end
		@next_button = Qt::PushButton.new ">"
		@pagination_buttons_layout.addWidget @next_button
		@next_button.connect SIGNAL :clicked do display_create_page end
		@last_button = Qt::PushButton.new ">>"
		@pagination_buttons_layout.addWidget @last_button
		@last_button.connect SIGNAL :clicked do display_create_page end
	end

	def add_main_button_group
		@main_actions = Qt::Widget.new
		@main_actions.set_fixed_size @list_width, 50
		setStyleSheet("QGroupBox {background-color: red;}")
		@main_buttons_layout = Qt::HBoxLayout.new @main_actions
		@main_buttons_layout.set_contents_margins 10, 0, 0, 20
		@layout.addWidget @main_actions, 3, Qt::AlignTop
		add_create_button
		add_import_button
	end

	def add_create_button
		create_button = Qt::PushButton.new "Créer utilisateur"
		create_button.connect SIGNAL :clicked do display_create_page end
		@main_buttons_layout.addWidget create_button
	end

	def add_import_button
		create_button = Qt::PushButton.new "Importer liste utilisateurs"
		create_button.connect SIGNAL :clicked do display_import_page end
		@main_buttons_layout.addWidget create_button
	end

	def add_user_panel
		@panel_width = 400
		@user_panel.setFixedSize @panel_width, @user_panel.height
		@user_panel.move geometry.x + @list_width + 20, geometry.y
		add_panel_parts unless @selected_user.blank?
		@user_panel.hide
	end

	def add_panel_parts
		@user_panel_layout = Qt::VBoxLayout.new @user_panel
		@user_panel_layout.set_contents_margins 20, 0, 0, 20
		add_portrait
		add_user_info
		add_user_button_group
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

	def add_user_button_group
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
		set_fixed_size @user_list.width + 20, [@user_list.height + @main_actions.height + 100, 580].max
		center_window
        setWindowTitle "GSB : Gérer utilisateurs"
        show
	end

	def display_create_page
		UserController.new.create
		self.close
	end

	def display_import_page
		self.close
		UserController.new.import
	end

	def display_edit_page
		UserController.new.update @selected_user
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
			setFixedSize @user_list.width + 20, @user_list.height + @main_actions.height + 20
		end
	end

	def closeEvent(event)
	    @user_panel.close
  	end

  	def moveEvent(event)
	    @user_panel.move event.pos.x + width, event.pos.y
  	end
end