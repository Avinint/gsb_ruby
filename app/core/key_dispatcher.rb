require 'Qt'

class KeyDispatcher < Qt::Object
    def initialize
       super
    end

    def eventFilter(object, event)
      if event.type() == Qt::Event::KeyRelease 
        
        if event.key == Qt::Key_Return
          new_event = Qt::Event::KeyRelease, Qt::Key_Space, Qt::NoModifier
          #Qt::CoreApplication.sendEvent object, new_event
        else
          return super(object, event)
        end
        return false
      end
    end
end