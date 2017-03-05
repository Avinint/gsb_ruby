class Widget::UsersTable < Qt::TableWidget

	slots "mousePressEvent(event)"

	def initialize rows, headers = nil
		super()
		@rows = rows
		@selected_row = @rows[1]
		@headers = headers || rows.first.class.column_names
		@headers.push "actions"
		@columns  = @headers.map { |header| header.parameterize.underscore }
		set_row_count  rows.size
		set_column_count @headers.size 
		
		setHorizontalHeaderLabels headers
		verticalHeader.setVisible false
		verticalHeader.width =  0

		setSelectionBehavior Qt::AbstractItemView::SelectRows
		setSelectionMode Qt::AbstractItemView::SingleSelection
		populate
		computeSize
	end

	def populate 
		
		@rows.each_with_index do |row, row_index|
			@columns.each_with_index do |column, col_index|
				if column != "actions"
					data = row.send(column).to_s
					item = Qt::TableWidgetItem.new data
					#@table.setCellWidget(row_index, col_index, label)
					setItem(row_index, col_index, item)
				else

					add_buttons row_index, col_index
				end
				#@table.connect(SIGNAL(pressed (const QModelIndex &))) { puts @table.currentItem.column}
      			#$qApp.connect(label, SIGNAL('clicked()'),  $qApp, SLOT('quit'))
      			#label.clicked.connect {|index|}
      			
			end	
		end
	end

	def add_buttons x, y
		editButton = Qt::PushButton.new "modifier"
		setCellWidget(x, y, editButton)
		editButton.connect(SIGNAL('clicked()'))  { |x, y| $qApp.quit }
	end

	def display_data utilisateur
		#User::Index show
		parent.user_display.data = utilisateur
		parent.user_display.populate
		parent.user_panel.show
		
		 	parent.load_file utilisateur.image
		 
		resizeColumnsToContents
		parent.setFixedSize width + parent.panel_width, height + 20
		
	end

	def computeSize
		setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff)
		setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff)
		resizeColumnsToContents
		
		setFixedSize(horizontalHeader.length, verticalHeader.length + horizontalHeader.height)
	end

	def mousePressEvent(event)
	    if event.button() == Qt::RightButton
			parent.user_panel.resize 0, parent.user_panel.height
			parent.setFixedSize width + 20, height + 20
			parent.user_panel.hide
			
	   	
	   	elsif event.button() == Qt::LeftButton
	   		index = indexAt(event.pos).row
	   		select_row(index)
	   		display_data @rows[index]
		end
  	end
end