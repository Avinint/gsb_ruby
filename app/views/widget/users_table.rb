class Widget::UsersTable < Qt::TableWidget

	slots "mousePressEvent(event)"

	def initialize headers = nil
		super()
		@headers = headers || parent.selected_user.class.column_names || Utilisateur.column_names
		@headers.push "actions" if @headers.present?
		set_content
		set_style
	end

	def set_content
		@rows = Utilisateur.all
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
			item = Qt::TableWidgetItem.new(row.send(column).to_s)
			item.setFlags(Qt::ItemIsEnabled)
			set_item(row_index, col_index, item)
		else
			add_buttons row_index, col_index
		end	
	end

	def add_buttons x, y
		editButton = Qt::PushButton.new "modifier"
		setCellWidget(x, y, editButton)
		editButton.connect(SIGNAL('clicked()'))  { |x, y| $qApp.quit }
	end

	def display_data
		parent.user_display.populate parent.selected_user
		parent.user_panel.show
	 	parent.load_file
		resizeColumnsToContents
		parent.setFixedSize width + parent.panel_width, [height + 20, 500].max
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
   		select_user index
  	end

  	def select_user index
  		select_row index
   		parent.selected_user = @rows[index]
   		display_data
  	end

  	def right_click
  		parent.user_panel.resize 0, parent.user_panel.height
		parent.setFixedSize width + 20, height + 20
		parent.user_panel.hide
  	end
end