require 'Qt'
require 'mail'
require 'yaml'
require 'active_record'
require 'active_support/all'
extend ActiveSupport::Autoload

relative_load_paths = %w[core controllers models views factories].map {|path| path.prepend("app/")}

ActiveSupport::Dependencies.autoload_paths += relative_load_paths

class Gsb
    def initialize
    	@dbc = YAML::load(File.open(File.expand_path("database.yml", File.dirname(__FILE__))))
    	active_db = @dbc["development"]
    	ActiveRecord::Base.establish_connection(active_db)
		ActiveRecord::Base.pluralize_table_names = false
        options = { address:           "smtp.gmail.com",
                    port:              587,
                    domain:            'brunoa.com',
                    user_name:         'team.gsble@gmail.com',
                    password:          'riveton42',
                    authentication:    'plain',
                enable_starttls_auto:  true  }
        Mail.defaults do
            delivery_method :smtp, options
        end
		$screen = Qt::Application::desktop.screenGeometry
		id = Qt::FontDatabase::addApplicationFont("app/fonts/RobotoSlab-Regular.ttf")
 	end

 	def display_login_page  
 		HomeController.new.login
    end
end

GC.disable
$gsb_session = {}
$qApp = Qt::Application.new ARGV
icon = Qt::Icon.new "app/images/logo-sm.ico"
$qApp.set_window_icon icon
#$qApp.installEventFilter(KeyDispatcher.new)
#Qt.debug_level = Qt::DebugLevel::High
# necessaire pour support du format jpg !!! :
Qt::Application.instance.addLibraryPath(Qt::PLUGIN_PATH)
gsb = Gsb.new
gsb.display_login_page
$qApp.exec
GC.enable