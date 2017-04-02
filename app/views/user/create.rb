require 'Qt'

class User::Create < Widget::UserForm
	def initialize user
		super
		add_top_menu_bar
		add_top_label
		setWindowTitle "GSB : Créer utilisateur"
		set_fixed_size width * 2/3, height
		center_window
    	show
	end

	def add_top_menu_bar
		menu_bar = GSBMenuBar.new self
		@layout.insert_widget 0, menu_bar
	end

	def add_top_label
		label = Qt::Label.new
		image = Qt::Pixmap.new("app/images/background.jpg")
		image = image.scaled(400, 50, Qt::KeepAspectRatioByExpanding, Qt::SmoothTransformation)
		set_fixed_size width, height + label.geometry.height / 4
		#set_style_sheet "QLabel {background-color: green; color: white}"
		label.pixmap = image
		label.setAlignment Qt::AlignCenter
		@layout.insert_widget 1, label
	end
end