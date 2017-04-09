require 'Qt'

class Window < Qt::Frame

	def initialize
		super
		center_window
		@resized = false
		set_style_sheet "QFrame QPushButton{height: 30px; 
		border-radius: 3px;
		background-color: #f56a6a; 
		color: white;
		font-weight: bold;}
		QTableWidget::item:selected {background-color: #f56a6a; color :white; font-weight: 700}
		"

 	end

 	def setFixedSize x, y
 		super 
 		center_window unless @resized == true
 		@resized = true
 	end

 	def resize x, y
 		super
 		center_window unless @resized == true
 		@resized = true
 	end

 	def center_window
 		x = ($screen.width - width) / 2
		y = ($screen.height - height) / 2
		move x, y
 	end

 	def current_user
    	return unless $gsb_session[:current_user].present?
    	@current_user ||= $gsb_session[:current_user]
  	end

	def set_button_font widget
  		font = Qt::Font.new "Roboto", 9, Qt::Font::Light
		font.setLetterSpacing(Qt::Font::PercentageSpacing, 99)
		widget.set_font font
  	end

	def set_popup_font widget
  		font = Qt::Font.new "Roboto", 9, Qt::Font::Light
		font.setLetterSpacing(Qt::Font::PercentageSpacing, 99)
		widget.set_font font
  	end

  	def set_header_font widget
  		font = Qt::Font.new "Roboto Slab", 9, Qt::Font::Light
		font.setLetterSpacing(Qt::Font::PercentageSpacing, 99)
		widget.set_font font
  	end

  	def add_header text, w = 600
		@header = Qt::Widget.new
		@header.set_fixed_size w, 15
		@header_layout = Qt::HBoxLayout.new @header
		@header_layout.set_contents_margins 0, 0, 0, 0
		@layout.insert_widget 1, @header
		@display_user = Qt::Label.new "#{current_user.nom_complet} - Administrateur"
		set_header_font @display_user
		@display_title = Qt::Label.new text
		@display_title.set_alignment Qt::AlignRight
		@display_user.set_fixed_size 250, 20
		@display_title.set_fixed_size 130, 20
		set_header_font @display_title
		@header_layout.add_widget @display_user, 1, Qt::AlignLeft
		@header_layout.add_widget @display_title, 1, Qt::AlignRight
		hr = Qt::Label.new
		hr.set_fixed_size width, 7
		line = Qt::Pixmap.new w, 5
		line.fill(Qt::Color.new "#f56a6a")
		hr.pixmap = line
		@layout.insert_widget 2, hr
	end
end
