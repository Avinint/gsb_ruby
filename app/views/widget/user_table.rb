class Widget::UserTable < Qt::TableWidget

	def initialize user
		super()
		headers = %w(login prénom nom rôle  email téléphone adresse commune date_embauche)
		@attributes = headers.map { |header| header.parameterize.underscore }
		set_row_count  headers.count
		setFixedSize 360, 340
		set_column_count 1
		horizontalHeader.setVisible false
		setVerticalHeaderLabels headers
		horizontalHeader.setResizeMode Qt::HeaderView::Stretch 
		setSelectionBehavior Qt::AbstractItemView::NoSelection
		populate user unless user.blank?
	end

	def populate user
		@attributes.each_with_index do |row, index|
			value = user.send(row).to_s
			item  = Qt::TableWidgetItem.new value
			item.setFlags(Qt::ItemIsEnabled )
			setItem(index, 0, item)
		end
	end

	def add_buttons x, y
		editButton = Qt::PushButton.new "modifier"
		setCellWidget(x, y, editButton)
		editButton.connect(SIGNAL('clicked()'))  { |x, y| $qApp.quit }
	end
	
end