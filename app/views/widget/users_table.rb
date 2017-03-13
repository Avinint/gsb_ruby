class Widget::UsersTable < Qt::TableWidget

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
		add_button 0, last_column
	end

	def populate_index column, row, row_index, col_index
		if column != "actions"
			item = Qt::TableWidgetItem.new(row.send(column).to_s)
			item.setFlags(Qt::ItemIsEnabled)
			set_item(row_index, col_index, item)
		end	
	end

	def add_button x, y
		edit_button = Qt::PushButton.new "modifier"
		setCellWidget(x, y, edit_button)
		edit_button.connect SIGNAL :clicked do 
			parent.display_edit_page
		end
	end

	def remove_button x, y
		remove_cell_widget x, y
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
   		select_user index if index > -1
  	end

  	def select_user index
  		add_button index, last_column
  		remove_button current_row, last_column unless current_row == index
  		select_row index
   		parent.selected_user = @rows[index]
   		display_data
  	end
	
	def display_data
		parent.user_display.populate parent.selected_user
		#parent.setFixedSize width + parent.panel_width + 20, [height + 100, 400].max
		parent.user_panel.show
		parent.user_panel.raise
	 	parent.load_file
		resizeColumnsToContents
	end


  	def right_click
  		parent.user_panel.resize 0, parent.user_panel.height
		parent.setFixedSize width + 20, [height + 100, 400].max
		parent.user_panel.hide
  	end
	
	def remove_row index
		super
		@rows.reload
	end

	def last_column
		column_count - 1
	end
end