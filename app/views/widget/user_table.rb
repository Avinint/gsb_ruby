class Widget::UserTable < Qt::TableWidget

	attr_accessor :data

	def initialize data
		super()
		@data = data
		headers = %w(login prénom nom rôle  email téléphone adresse commune date_embauche)
		@attributes = headers.map { |header| header.parameterize.underscore }
		set_row_count  headers.count
		setFixedSize 360, height
		set_column_count 1
		horizontalHeader.setVisible false
		setVerticalHeaderLabels headers
		horizontalHeader.setResizeMode Qt::HeaderView::Stretch 

		setSelectionBehavior Qt::AbstractItemView::NoSelection
		populate

	end

	def populate 	
		@attributes.each_with_index do |row, index|
			value = @data.send(row).to_s
			item = Qt::TableWidgetItem.new value
			item.setFlags(Qt::ItemIsEnabled )
			setItem(index, 0, item)
			#@table.connect(SIGNAL(pressed (const QModelIndex &))) { puts @table.currentItem.column}
  			#$qApp.connect(label, SIGNAL('clicked()'),  $qApp, SLOT('quit'))
  			#label.clicked.connect {|index|}
		end
	end

	def add_buttons x, y
		editButton = Qt::PushButton.new "modifier"
		setCellWidget(x, y, editButton)
		editButton.connect(SIGNAL('clicked()'))  { |x, y| $qApp.quit }
	end
	
end