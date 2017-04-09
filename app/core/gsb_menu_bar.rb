require 'Qt'

class GSBMenuBar < Qt::MenuBar

	def initialize parent
		super()
		#set_style_sheet "QMenuBar {background-color: #f56a6a}"
		@file  = add_menu "fichier"
		@tools = add_menu "outils" if parent.current_user.is_admin?
		
		add_exiter
		add_disconnecter
		if parent.current_user.is_admin?
			add_user_indexer  unless parent.class == User::Index
			add_user_adder    unless parent.class == User::Create
			add_user_importer unless parent.class == User::Import || parent.class == User::Create || parent.class == User::Update
		end
 	end

 	def add_exiter
 		exit = Qt::Action.new "fermer", parent
		exit.connect SIGNAL :triggered do
			$qApp.quit
		end
		@file.add_action exit
 	end

 	def add_disconnecter
 		logout = Qt::Action.new "Se déconnecter", parent
 		logout.connect SIGNAL :triggered do
			Auth.logout
			HomeController.new.login
			parent.close
 		end
 		@file.add_action logout
 	end

 	def add_user_indexer
 		index_user = Qt::Action.new "afficher liste utilisateurs", parent
		index_user.connect SIGNAL :triggered do
			parent.close
			UserController.new.index
		end
		@tools.add_action index_user
 	end

 	def add_user_adder
 		add_user = Qt::Action.new "ajouter utilisateur", parent
		add_user.connect SIGNAL :triggered do
			parent.close
			UserController.new.create
		end
		@tools.add_action add_user
 	end

 	def add_user_importer
 		import_user = Qt::Action.new "importer utilisateur", parent
		import_user.connect SIGNAL :triggered do
			UserController.new.import parent
		end
		@tools.add_action import_user
		
 	end
end