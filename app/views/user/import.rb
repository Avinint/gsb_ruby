require 'Qt'
require 'CSV'

class User::Import < Qt::FileDialog
	def initialize
		super
		setWindowTitle "GSB : Importer utilisateur"
    	show
    	if self.exec
    		file = File.read selected_files.first, encoding: "UTF-8"
    		if(!file) 
    			Qt::MessageBox.information 0, "error", file.error_string
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
end