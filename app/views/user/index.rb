require 'Qt'
require 'pathname'

class User::Index < Window

	attr_reader :user_panel, :user_display, :panel_width, :list_width
	attr_accessor :user_list, :selected_user, :first_button, :last_button, :prev_button, :next_button

	def initialize
		super()
		
		@page = 1
		@selected_user = Utilisateur.first 
		@layout 	   = Qt::VBoxLayout.new self
		@user_panel    = Window.new
		add_top_menu_bar
		add_header "Index utilisateurs", (width - 43)
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
		image = image.scaled(600, 50, Qt::KeepAspectRatioByExpanding, Qt::SmoothTransformation)
		
		#set_style_sheet "QLabel {background-color: green; color: white}"
		label.pixmap = image
		label.setAlignment Qt::AlignCenter
		@layout.add_widget label
	end

	def add_user_list
		@user_list = Widget::UsersTable.new ["login", "prénom", "nom", "rôle", "commune"]
		layout.addWidget @user_list, 2, Qt::AlignTop
		@list_width = @user_list.width
		@user_list.select_row 0
	end

	def add_pagination_button_group
		@pagination_actions = Qt::Widget.new
		@pagination_actions.set_fixed_size @list_width, 50
		
		@pagination_buttons_layout = Qt::HBoxLayout.new @pagination_actions
		@pagination_buttons_layout.set_contents_margins 0, 0, 0, 0
		@layout.addWidget @pagination_actions, 1, Qt::AlignTop
		
		@first_button = Qt::PushButton.new "<<"
		@pagination_buttons_layout.addWidget @first_button 
		@first_button.connect SIGNAL :clicked do @user_list.set_page 1 end
		@first_button.hide
		@prev_button = Qt::PushButton.new "<"
		@pagination_buttons_layout.addWidget @prev_button
		@prev_button.connect SIGNAL :clicked do  @user_list.set_page(@user_list.current_page - 1)  end
		@prev_button.hide
		@next_button = Qt::PushButton.new ">"
		@pagination_buttons_layout.addWidget @next_button
		@next_button.connect SIGNAL :clicked do @user_list.set_page(@user_list.current_page + 1)  end
		@next_button.hide if @user_list.nbr_page == 1
		@last_button = Qt::PushButton.new ">>"
		@pagination_buttons_layout.addWidget @last_button
		@last_button.connect SIGNAL :clicked do @user_list.set_page @user_list.nbr_page end
		@last_button.hide if @user_list.nbr_page == 1
	end

	def add_main_button_group
		@main_actions = Qt::Widget.new
		@main_actions.set_fixed_size @list_width, 50
		@main_buttons_layout = Qt::HBoxLayout.new @main_actions
		@main_buttons_layout.set_contents_margins 0, 0, 0, 0
		@layout.addWidget @main_actions, 3, Qt::AlignTop
		add_create_button
		add_import_button
	end

	def add_create_button
		button = Qt::PushButton.new "Creer utilisateur".upcase
		set_button_font button
		button.connect SIGNAL :clicked do display_create_page end
		@main_buttons_layout.addWidget button
	end

	def add_import_button
		button = Qt::PushButton.new "Importer liste utilisateurs".upcase
		set_button_font button
		button.connect SIGNAL :clicked do display_import_page end
		@main_buttons_layout.addWidget button
	end

	def add_user_panel
		@panel_width = 400
		@user_panel.setFixedSize @panel_width, 540
		@user_panel.move geometry.x + @list_width + 20, geometry.y
		add_panel_parts unless @selected_user.blank?
		@user_panel.set_window_title "GSB : Consulter profil #{@selected_user.nom_complet}"
		@user_panel.hide
	end

	def add_panel_parts
		@user_panel_layout = Qt::VBoxLayout.new @user_panel
		@user_panel_layout.set_contents_margins 20, 0, 20, 0
		@user_panel_layout.set_spacing 2
		add_portrait
		add_user_info
		add_user_button_group
	end

	def add_portrait
		@user_portrait = Qt::Label.new
		load_file
		@user_portrait.setFixedSize 360, 120
		@user_portrait.alignment = Qt::AlignCenter
		@user_panel_layout.addWidget @user_portrait, 1, Qt::AlignHCenter
	end

	def load_file
		file_name = "user.jpg"  # @selected_user.image || 
		image = Qt::Pixmap.new "images/avatars/#{file_name}"
		h 	  = @user_portrait.height
		w     = @user_portrait.height
		@user_portrait.pixmap = image.scaledToHeight(h, Qt::SmoothTransformation)
	end

	def add_user_info
		@user_display = Widget::UserTable.new @selected_user
		@user_panel_layout.addWidget @user_display, 1
	end

	def add_user_button_group
		user_actions = Qt::Widget.new
		user_actions.set_fixed_size 360, 35
		@actions_layout = Qt::HBoxLayout.new user_actions
		@actions_layout.set_contents_margins 5, 0, 5, 0
		@user_panel_layout.addWidget user_actions, 1
		add_edit_button
		add_delete_button
	end

	def add_edit_button
		edit_button = Qt::PushButton.new "modifier".upcase
		set_button_font edit_button
		edit_button.connect SIGNAL :clicked do display_edit_page end
		@actions_layout.addWidget edit_button
	end

	def add_delete_button
		delete_button = Qt::PushButton.new "supprimer".upcase
		set_button_font delete_button
		delete_button.connect SIGNAL :clicked do confirm_delete end
		@actions_layout.addWidget delete_button
	end

	def display_window
		set_fixed_size @user_list.width + 20, @user_list.height + 310
		center_window
        setWindowTitle "GSB : Gérer utilisateurs"
        show
	end

	def display_create_page
		self.close
		UserController.new.create
	end

	def display_import_page
		@import_dialog = UserController.new.import self
	end

	def display_edit_page
		self.close
		UserController.new.update @selected_user
	end

	def confirm_delete
		popup = Qt::MessageBox.new self
		popup.window_title = 'GSB'; popup.icon = Qt::MessageBox::Critical
		popup.text = "Voulez-vous vraiment supprimer cet utilisateur?"
		popup.standardButtons  = Qt::MessageBox::Ok | Qt::MessageBox::Cancel
		popup.set_contents_margins 0,0,0,0
		popup.set_style_sheet "QPushButton {background-color: white; color: black; 
		height: 10px; min-width: 100px;padding: 6px 3px 6px 3px; border: 1px solid black;
		border-radius: 0; 
		}"
		set_popup_font popup
		
		popup.findChildren(Qt::PushButton).each do |widget|
			widget.set_flat false
		end
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
		end
	end

	def closeEvent(event)
	    @user_panel.close
	    @import_dialog.close if @import_dialog.present?
  	end

  	def moveEvent(event)
	    @user_panel.move event.pos.x + width, event.pos.y
  	end
end