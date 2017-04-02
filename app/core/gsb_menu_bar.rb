require 'Qt'

class GSBMenuBar < Qt::MenuBar

	def initialize parent
		super()
		#set_style_sheet "QMenuBar {background-color: #f56a6a}"
		@file  = add_menu "fichier"
		@tools = add_menu "outils"
		
		add_exiter
		add_user_indexer  unless parent.class == User::Index
		add_user_adder    unless parent.class == User::Create
		add_user_importer unless parent.class == User::Import
 	end

 	def add_exiter
 		exit = Qt::Action.new "fermer", parent
		exit.connect SIGNAL :triggered do
			$qApp.quit
		end
		@file.add_action exit
 	end

 	def add_user_indexer
 		index_user = Qt::Action.new "afficher liste utilisateurs", parent
		index_user.connect SIGNAL :triggered do
			UserController.new.index
			parent.close
		end
		@tools.add_action index_user
 	end

 	def add_user_adder
 		add_user = Qt::Action.new "ajouter utilisateur", parent
		add_user.connect SIGNAL :triggered do
			UserController.new.create
			parent.close
		end
		@tools.add_action add_user
 	end

 	def add_user_importer
 		import_user = Qt::Action.new "importer utilisateur", parent
		import_user.connect SIGNAL :triggered do
			parent.close
			UserController.new.import
		end
		@tools.add_action import_user
		
 	end
end