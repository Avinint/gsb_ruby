require 'Qt'

class Home::Welcome < Window
	def initialize
		super
		setStyleSheet("QPushButton {color: #f56a6a; height: 45px; border: 2px solid #f56a6a; padding: 0px 33px; border-radius: 6px}")
		page = Qt::HBoxLayout.new
		setLayout page
		menu = Qt::VBoxLayout.new
		splash = Qt::BoxLayout.new Qt::BoxLayout::TopToBottom
		page.addLayout menu, 1
		page.addLayout splash, 1
		menu.setSpacing 5
		menu.setContentsMargins 20, 0, 20, 0
		
		button_font = Qt::Font.new "Roboto Slab", 10, Qt::Font::DemiBold
		
		/info = Qt::FontInfo.new  button_font
		puts info.pointSize
		puts info.family/
		
		button_font.setLetterSpacing(Qt::Font::PercentageSpacing, 99)

		user_list 	= Qt::PushButton.new 'Liste utilisateurs'.upcase
		add_user 	= Qt::PushButton.new 'Ajouter'.upcase
		import_users = Qt::PushButton.new 'Importer'.upcase
		menu.addWidget user_list, 0, Qt::AlignTop
		menu.addWidget add_user, 0, Qt::AlignTop
		menu.addWidget import_users, 1, Qt::AlignTop
		(0..menu.count - 1).each do |index|
			menu.itemAt(index).widget.setFont button_font
			menu.itemAt(index).widget.setFlat true
		end

		user_list.connect SIGNAL :clicked do
			UserController.new.index
			self.hide
		end
		add_user.connect SIGNAL :clicked do
			UserController.new.create
			self.hide
		end

		import_users.connect SIGNAL :clicked do
			UserController.new.import
		end

		splash_label = Qt::Label.new
		#font = Qt::Font.new "Helvetica", 12
		h = splash_label.height
		w = splash_label.width
		image = Qt::Pixmap.new ("app/images/pic12.jpg")
		image = image.scaled(w/2, h/2, Qt::KeepAspectRatio, Qt::SmoothTransformation)
		splash_label.resize 100, 100
		
		
		splash_label.pixmap =  image
		splash.addWidget splash_label, 1, Qt::AlignTop
		#str = tr("here is my text")
		#splash_label.text = str
		
    		
        setFixedSize 600,  240
        setWindowTitle "GSB : Back office"
       
        show
	end
end