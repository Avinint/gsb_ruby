class Widget::UsersTable < Qt::TableWidget

	slots "mousePressEvent(event)"

	def initialize rows, headers = nil
		super()
		@rows = rows
		@headers = headers || rows.first.class.column_names
		@headers.push "actions"
		set_content
		set_style
	end

	def set_content
		@columns = @headers.map { |header| header.parameterize.underscore }
		set_row_count @rows.size
		set_column_count @headers.size 
		setHorizontalHeaderLabels @headers
		populate
	end

	def set_style
		verticalHeader.setVisible false
		verticalHeader.width = 0
		setSelectionBehavior Qt::AbstractItemView::SelectRows
		setSelectionMode Qt::AbstractItemView::SingleSelection
		compute_size
	end

	def populate 
		@rows.each_with_index do |row, row_index|
			@columns.each_with_index do |column, col_index|
				populate_index column, row, row_index, col_index
			end	
		end
	end

	def populate_index column, row, row_index, col_index
		if column != "actions"
			set_item(row_index, col_index, Qt::TableWidgetItem.new(row.send(column).to_s))
		else
			add_buttons row_index, col_index
		end	
	end

	def add_buttons x, y
		editButton = Qt::PushButton.new "modifier"
		setCellWidget(x, y, editButton)
		editButton.connect(SIGNAL('clicked()'))  { |x, y| $qApp.quit }
	end

	def display_data utilisateur
		parent.user_display.populate utilisateur
		parent.user_panel.show
	 	parent.load_file utilisateur.image
		resizeColumnsToContents
		parent.setFixedSize width + parent.panel_width, height + 20
	end

	def compute_size
		setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff)
		setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff)
		resizeColumnsToContents
		setFixedSize(horizontalHeader.length, verticalHeader.length + horizontalHeader.height)
	end

	def mousePressEvent(event)
	    if event.button() == Qt::RightButton
			right_click
	   	elsif event.button() == Qt::LeftButton
	   		left_click event
		end
  	end

  	def left_click event
  		index = indexAt(event.pos).row
   		select_row(index)
   		display_data @rows[index]
  	end

  	def right_click
  		parent.user_panel.resize 0, parent.user_panel.height
		parent.setFixedSize width + 20, height + 20
		parent.user_panel.hide
  	end
end