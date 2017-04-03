class Widget::UsersTable < Qt::TableWidget

	attr_accessor :current_page
	attr_reader  :nbr_page

	def initialize headers = nil, page = 1
		super()
		@headers = headers || parent.selected_user.class.column_names || Utilisateur.column_names
		@current_page = page
		@headers.push "actions" if @headers.present?
		set_content
		set_style
	end

	def set_content
		@columns = @headers.map { |header| header.parameterize.underscore }
		set_column_count @headers.size 
		setHorizontalHeaderLabels @headers
		set_rows
	end

	def set_rows
		pagination = UserController.new.paginate @current_page
		@rows = pagination[:list]
		@total_count = pagination[:count]
		@nbr_page = pagination[:nbr_page]
		@current_page = @nbr_page if (@current_page > @nbr_page)
		@current_page = 1 if (@current_page < 1)
		set_row_count @rows.size
		populate
	end

	def set_buttons
		if @current_page == 1
			parent.first_button.hide
			parent.prev_button.hide
		else
			parent.first_button.show
			parent.prev_button.show
		end
		if @current_page == @nbr_page
			parent.last_button.hide
			parent.next_button.hide
		else
			parent.last_button.show
			parent.next_button.show
		end
		
	end

	def set_page page
		@current_page = page unless page > @nbr_page
		empty
		set_rows
		select_user 0
		set_buttons
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

	def empty
		@rows.each_with_index do |row, row_index|
			remove_row row_index
		end
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
		#resizeColumnsToContents
		#resizeRowsToContents
		setFixedSize([500, horizontalHeader.length + verticalHeader.width].max, verticalHeader.length + horizontalHeader.height + 10)
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
		if parent.present?
			parent.user_display.populate parent.selected_user
			#parent.setFixedSize width + parent.panel_width + 20, [height + 100, 400].max
			if parent.user_panel.present?
				parent.user_panel.show
				parent.user_panel.raise
				#parent.load_file
			end
		end
	end

  	def right_click
  		parent.user_panel.resize 0, parent.user_panel.height
		#parent.setFixedSize width + 20, [height + 101, 580].max
		parent.user_panel.hide
  	end
	
	def remove_row index
		super
		@rows.reload
	end

	def last_column
		column_count - 1
	end

	def wheelEvent event 
		return false
	end
end