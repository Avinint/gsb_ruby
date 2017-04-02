require 'Qt'
require 'CSV'

class User::Import < Qt::FileDialog
	def initialize
		super
		add_top_menu_bar
		show
		setWindowTitle "GSB : Importer utilisateur"

    	if self.exec
    		if self.exec == Qt::Dialog::Accepted
	    		file = File.read selected_files.first, encoding: "UTF-8" unless File.directory? selected_files.first
	    		if !file
	    			return false
				end
				input = Qt::TextStream.new file
				csv_reader = CSV.parse(file, row_sep: :auto, col_sep: ";", quote_char: '"', headers: :first_row, return_headers: false)
				csv_reader.each do |row|
					row = row.to_h

					Utilisateur.create! row unless Utilisateur.unique_values_exist row
				end
	    		self.close
	    		UserController.new.index
    		elsif self.exec == Qt::Dialog::Rejected
    			UserController.new.index
    		end
    	end
	end

	def add_top_menu_bar
		@menu_bar = GSBMenuBar.new self
		layout.add_widget @menu_bar, 0, 0
	end
end