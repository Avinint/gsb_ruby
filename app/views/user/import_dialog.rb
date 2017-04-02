require 'Qt'
require 'CSV'

class User::Import < Qt::FileDialog
	def initialize
		super
		add_top_menu_bar
		setWindowTitle "GSB : Importer utilisateur"
    	show
    	if self.exec
    		file = File.read selected_files.first, encoding: "UTF-8" unless File.directory? selected_files.first
    		if !file
    			return false
			end
			input = Qt::TextStream.new file
			csv_reader = CSV.parse(file, row_sep: :auto, col_sep: ";", quote_char: '"', headers: :first_row, return_headers: false)
			csv_reader.each do |row|
				Utilisateur.create! row.to_h
			end
			#input = Qt::TextStream.new file
			#first_line = input.read_line
			#fields = first_line.split ";"
			#print fields
			#until input.at_end
			#	line = input.read_line
			#	fields = line.split ";"
			#	fields.each {|f| puts f}
			#end
			
    		self.close
    	end
	end

	def add_top_menu_bar
		@menu_bar = GSBMenuBar.new self
		layout.add_widget @menu_bar, 0, 0
	end
end