require 'Qt'

class User::EditPassword < Qt::Dialog
	def initialize parent
		super()
		@parent = parent
		setWindowTitle "GSB : Changer mot de passe"
		form = Qt::FormLayout.new self
		@password_line_edit = Qt::LineEdit.new
		@password_confirm_edit = Qt::LineEdit.new
   		@password_line_edit.setEchoMode Qt::LineEdit::Password
   		@password_confirm_edit.setEchoMode Qt::LineEdit::Password
		form.addRow "&Mot de passe", @password_line_edit
       	form.addRow "&Confirmer", @password_confirm_edit
       	submit = Qt::PushButton.new "Changer"
       	form.addRow submit
       	set_fixed_size 300, 100
       	show
       	submit.connect SIGNAL :clicked do
       		change_password
       	end

		if self.exec == Qt::Dialog::Accepted
   #  		file = File.read selected_files.first, encoding: "UTF-8" unless File.directory? selected_files.first
   #  		if !file
   #  			return false
			# end
			# input = Qt::TextStream.new file
			# csv_reader = CSV.parse(file, row_sep: :auto, col_sep: ";", quote_char: '"', headers: :first_row, return_headers: false)
			# csv_reader.each do |row|
			# 	row = row.to_h
			# 	row[:role] = "visiteur" if row[:role].blank?
			# 	Utilisateur.create! row unless Utilisateur.unique_values_exist row		
			# end
			# @parent.user_list.reload_list
		end
    	self.close
	end

	def change_password
		confirmed = @password_line_edit.text == @password_confirm_edit.text
		if confirmed
			message = "mot de passe mis à jour" 
			current_user.mdp = Utilisateur.encrypt @password_line_edit.text
			current_user.save
		else
			message = "Echec confirmation de mot de passe"
		end
		popup = Qt::MessageBox.new self
		popup.window_title = 'GSB'
		popup.text = message
		popup.exec
		self.close
	end

	def current_user
		$gsb_session[:current_user]
	end
end