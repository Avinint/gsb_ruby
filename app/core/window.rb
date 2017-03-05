require 'Qt'

class Window < Qt::Widget

	def initialize
		super
		center_window
		@resized = false
 	end

 	def setFixedSize x, y
 		super 
 		center_window unless @resized == true
 		@resized = true
 	end

 	def resize x, y
 		super
 		center_window unless @resized == true
 		@resized = true
 	end

 	def center_window
 		x = ($screen.width - width) / 2
		y = ($screen.height - height) / 2
		move x, y
 	end

end