require 'Qt'
require 'yaml'
require 'active_record'
require 'active_support/all'
extend ActiveSupport::Autoload

relative_load_paths = %w[core controllers models views factories].map {|path| path.prepend("app/")}

ActiveSupport::Dependencies.autoload_paths += relative_load_paths

class Gsb
    def initialize
    	@dbc = YAML::load(ERB.new(  IO.read("database.yml")).result)
    	active_db = @dbc["development"]
    	ActiveRecord::Base.establish_connection(
    		adapter:  active_db["adapter"], 
            database: active_db["database"],
            host:	  active_db["host"], 
            username: active_db["username"], 
            password: active_db["password"])
        
		ActiveRecord::Base.pluralize_table_names = false
		$screen = Qt::Application::desktop.screenGeometry
		id = Qt::FontDatabase::addApplicationFont("app/fonts/RobotoSlab-Regular.ttf")
 	end

 	def display_login_page  
 		UserController.new.index #HomeController.new.login
    end
	
end

$gsb_session = {}
$qApp = Qt::Application.new ARGV
#Qt.debug_level = Qt::DebugLevel::High
# necessaire pour support du format jpg !!! :
Qt::Application.instance.addLibraryPath(Qt::PLUGIN_PATH)
gsb = Gsb.new
gsb.display_login_page
$qApp.exec