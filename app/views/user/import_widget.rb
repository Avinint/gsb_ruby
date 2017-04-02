require 'Qt'
require 'CSV'

class User::Import < Window
	def initialize
		super
		setWindowTitle "GSB : Importer utilisateurs"
		@layout = Qt::VBoxLayout.new self
		add_top_menu_bar
		add_import_button
    	show
	end

	def add_import_button
		import_button = Qt::PushButton.new "importer utilisateurs"
		@layout.add_widget import_button
		import_button.connect SIGNAL :clicked do
			User::ImportDialog.new
		end
	end

	def add_top_menu_bar
		@menu_bar = GSBMenuBar.new self
		@layout.add_widget @menu_bar
	end
end